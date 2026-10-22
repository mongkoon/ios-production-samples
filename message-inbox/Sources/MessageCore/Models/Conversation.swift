import Foundation

public struct Conversation: Identifiable, Hashable, Sendable {
    public let id: String
    public let participant: String
    public let preview: String
    public let lastActivity: Date
    public let unreadCount: Int

    public init(id: String, participant: String, preview: String, lastActivity: Date, unreadCount: Int = 0) {
        self.id = id
        self.participant = participant
        self.preview = preview
        self.lastActivity = lastActivity
        self.unreadCount = unreadCount
    }
}
