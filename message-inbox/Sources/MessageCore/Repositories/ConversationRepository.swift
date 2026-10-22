import Foundation

/// Defines the async boundary so production data sources can replace the demo repository.
public protocol ConversationRepository: Sendable {
    func searchConversations(query: String) async throws -> [Conversation]
    func messages(for conversationID: String) async throws -> [ChatMessage]
}
