import Foundation
import Observation

@MainActor
@Observable
public final class ConversationDetailModel {
    public private(set) var messages: [ChatMessage] = []
    public private(set) var state: LoadState = .idle

    @ObservationIgnored private let repository: any ConversationRepository
    @ObservationIgnored private let conversationID: String
    @ObservationIgnored private var epoch = 0

    public init(conversationID: String, repository: any ConversationRepository) {
        self.conversationID = conversationID
        self.repository = repository
    }

    public func load() async {
        epoch &+= 1
        let myEpoch = epoch
        state = .loading
        do {
            let fresh = try await repository.messages(for: conversationID)
            guard !Task.isCancelled, epoch == myEpoch else { return }
            messages = fresh
            state = .loaded
        } catch is CancellationError {
            // Cancellation is a lifecycle event rather than an error screen.
        } catch {
            guard !Task.isCancelled, epoch == myEpoch else { return }
            state = .failed("Could not load messages. Please try again.")
        }
    }
}
