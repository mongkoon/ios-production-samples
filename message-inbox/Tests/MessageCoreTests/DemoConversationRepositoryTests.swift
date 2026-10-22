import Testing
import MessageCore

@Suite("Demo repository")
struct DemoConversationRepositoryTests {
    @Test("Case-insensitive participant search")
    func participantSearch() async throws {
        let results = try await DemoConversationRepository().searchConversations(query: "aLeX")
        #expect(results.map(\.id) == ["alex"])
    }

    @Test("Searching message previews")
    func messageSearch() async throws {
        let results = try await DemoConversationRepository().searchConversations(query: "CHECKLIST")
        #expect(results.map(\.id) == ["morgan"])
    }

    @Test("Message detail is scoped to a conversation")
    func messages() async throws {
        let results = try await DemoConversationRepository().messages(for: "alex")
        #expect(results.count == 3)
        #expect(results.allSatisfy { $0.conversationID == "alex" })
        #expect(results.first?.sentAt ?? .distantFuture < results.last?.sentAt ?? .distantPast)
    }
}
