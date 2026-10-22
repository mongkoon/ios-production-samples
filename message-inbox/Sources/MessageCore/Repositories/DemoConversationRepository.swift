import Foundation

/// Entirely synthetic, deterministic content: no network calls and no personal data.
public struct DemoConversationRepository: ConversationRepository {
    public init() {}

    public func searchConversations(query: String) async throws -> [Conversation] {
        try await Task.sleep(for: .milliseconds(220))
        try Task.checkCancellation()
        let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches = keyword.isEmpty ? Self.conversations : Self.conversations.filter {
            $0.participant.localizedStandardContains(keyword) || $0.preview.localizedStandardContains(keyword)
        }
        return matches.sorted { $0.lastActivity > $1.lastActivity }
    }

    public func messages(for conversationID: String) async throws -> [ChatMessage] {
        try await Task.sleep(for: .milliseconds(140))
        try Task.checkCancellation()
        return Self.messages.filter { $0.conversationID == conversationID }.sorted { $0.sentAt < $1.sentAt }
    }

    private static let baseline = Date(timeIntervalSince1970: 1_782_000_000)

    public static let conversations: [Conversation] = [
        .init(id: "alex", participant: "Alex Kim", preview: "Let's review the prototype tomorrow.", lastActivity: baseline, unreadCount: 2),
        .init(id: "morgan", participant: "Morgan Lee", preview: "The release checklist is ready.", lastActivity: baseline.addingTimeInterval(-3600)),
        .init(id: "jamie", participant: "Jamie Park", preview: "I found the concurrency issue.", lastActivity: baseline.addingTimeInterval(-8500), unreadCount: 1),
        .init(id: "sam", participant: "Sam Taylor", preview: "Thank you for the code review!", lastActivity: baseline.addingTimeInterval(-86400)),
        .init(id: "river", participant: "River Chen", preview: "We can test the search edge case.", lastActivity: baseline.addingTimeInterval(-174000)),
        .init(id: "casey", participant: "Casey Miller", preview: "Updated the SwiftUI design notes.", lastActivity: baseline.addingTimeInterval(-260000))
    ]

    private static let messages: [ChatMessage] = [
        .init(id: "alex-1", conversationID: "alex", body: "Hi! Did you have time to check the sample?", sentAt: baseline.addingTimeInterval(-1000), isOutgoing: false),
        .init(id: "alex-2", conversationID: "alex", body: "Yes, the architecture looks much clearer now.", sentAt: baseline.addingTimeInterval(-600), isOutgoing: true),
        .init(id: "alex-3", conversationID: "alex", body: "Let's review the prototype tomorrow.", sentAt: baseline, isOutgoing: false),
        .init(id: "morgan-1", conversationID: "morgan", body: "The release checklist is ready.", sentAt: baseline.addingTimeInterval(-3600), isOutgoing: false),
        .init(id: "jamie-1", conversationID: "jamie", body: "I found the concurrency issue.", sentAt: baseline.addingTimeInterval(-8500), isOutgoing: false),
        .init(id: "sam-1", conversationID: "sam", body: "Thank you for the code review!", sentAt: baseline.addingTimeInterval(-86400), isOutgoing: false),
        .init(id: "river-1", conversationID: "river", body: "We can test the search edge case.", sentAt: baseline.addingTimeInterval(-174000), isOutgoing: false),
        .init(id: "casey-1", conversationID: "casey", body: "Updated the SwiftUI design notes.", sentAt: baseline.addingTimeInterval(-260000), isOutgoing: false)
    ]
}
