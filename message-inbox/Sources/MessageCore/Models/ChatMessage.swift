import Foundation

public struct ChatMessage: Identifiable, Hashable, Sendable {
    public let id: String
    public let conversationID: String
    public let body: String
    public let sentAt: Date
    public let isOutgoing: Bool

    public init(id: String, conversationID: String, body: String, sentAt: Date, isOutgoing: Bool) {
        self.id = id
        self.conversationID = conversationID
        self.body = body
        self.sentAt = sentAt
        self.isOutgoing = isOutgoing
    }
}
