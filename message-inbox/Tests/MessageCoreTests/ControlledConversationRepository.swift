import Foundation
import MessageCore

/// Manually controlled completions make concurrency regression tests deterministic.
/// Deliberately ignores cancellation to simulate an unreliable external API.
actor ControlledConversationRepository: ConversationRepository {
    private var pending: [String: CheckedContinuation<[Conversation], Error>] = [:]
    private var observers: [String: [CheckedContinuation<Void, Never>]] = [:]

    func searchConversations(query: String) async throws -> [Conversation] {
        try await withCheckedThrowingContinuation { continuation in
            pending[query] = continuation
            for observer in observers.removeValue(forKey: query) ?? [] { observer.resume() }
        }
    }

    func messages(for conversationID: String) async throws -> [ChatMessage] { [] }

    func waitForRequest(_ query: String) async {
        if pending[query] != nil { return }
        await withCheckedContinuation { continuation in
            observers[query, default: []].append(continuation)
        }
    }

    func succeed(_ query: String, results: [Conversation]) {
        pending.removeValue(forKey: query)?.resume(returning: results)
    }

    func fail(_ query: String) {
        pending.removeValue(forKey: query)?.resume(throwing: SimulatedError.unavailable)
    }

    enum SimulatedError: Error { case unavailable }
}
