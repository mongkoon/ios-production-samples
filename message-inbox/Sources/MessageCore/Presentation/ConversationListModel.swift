import Foundation
import Observation

/// UI state is main-actor isolated. Epoch checks complement cooperative cancellation
/// because third-party repositories may still return results after cancellation.
@MainActor
@Observable
public final class ConversationListModel {
    public private(set) var conversations: [Conversation] = []
    public private(set) var state: LoadState = .idle
    public private(set) var query: String = ""

    @ObservationIgnored private let repository: any ConversationRepository
    @ObservationIgnored private var epoch = 0

    public init(repository: any ConversationRepository) {
        self.repository = repository
    }

    /// Invalidate in-flight work immediately when text changes, before debounce finishes.
    public func updateQuery(_ newQuery: String) {
        guard query != newQuery else { return }
        query = newQuery
        epoch &+= 1
        conversations = []
        state = .loading
    }

    public func load() async {
        epoch &+= 1
        let myEpoch = epoch
        let requestedQuery = query
        state = .loading

        do {
            let fresh = try await repository.searchConversations(query: requestedQuery)
            guard !Task.isCancelled, epoch == myEpoch else { return }
            conversations = fresh
            state = .loaded
        } catch is CancellationError {
            // A new task will handle the latest query. Never show cancellation as an error.
        } catch {
            guard !Task.isCancelled, epoch == myEpoch else { return }
            state = .failed("Could not load conversations. Please try again.")
        }
    }
}
