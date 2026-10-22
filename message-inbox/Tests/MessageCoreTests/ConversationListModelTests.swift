import Foundation
import Testing
import MessageCore

@Suite("Conversation search state machine")
@MainActor
struct ConversationListModelTests {
    @Test("An older response cannot overwrite a newer query")
    func outOfOrderResults() async {
        let repository = ControlledConversationRepository()
        let model = ConversationListModel(repository: repository)
        let old = sample(id: "old")
        let new = sample(id: "new")

        model.updateQuery("first")
        let firstTask = Task { await model.load() }
        await repository.waitForRequest("first")

        model.updateQuery("second")
        let secondTask = Task { await model.load() }
        await repository.waitForRequest("second")

        await repository.succeed("second", results: [new])
        await secondTask.value
        await repository.succeed("first", results: [old])
        await firstTask.value

        #expect(model.conversations.map(\.id) == ["new"])
        #expect(model.state == .loaded)
    }

    @Test("An obsolete failed request does not display an error")
    func obsoleteFailure() async {
        let repository = ControlledConversationRepository()
        let model = ConversationListModel(repository: repository)

        model.updateQuery("first")
        let firstTask = Task { await model.load() }
        await repository.waitForRequest("first")
        model.updateQuery("second")
        let secondTask = Task { await model.load() }
        await repository.waitForRequest("second")

        await repository.succeed("second", results: [sample(id: "latest")])
        await secondTask.value
        await repository.fail("first")
        await firstTask.value

        #expect(model.conversations.map(\.id) == ["latest"])
        #expect(model.state == .loaded)
    }

    @Test("A failing active query produces a retryable error state")
    func activeFailure() async {
        let repository = ControlledConversationRepository()
        let model = ConversationListModel(repository: repository)

        model.updateQuery("broken")
        let task = Task { await model.load() }
        await repository.waitForRequest("broken")
        await repository.fail("broken")
        await task.value

        guard case .failed(let message) = model.state else {
            Issue.record("Expected error state")
            return
        }
        #expect(message.contains("try again"))
    }

    @Test("Cancellation never publishes a late result")
    func cancelledTask() async {
        let repository = ControlledConversationRepository()
        let model = ConversationListModel(repository: repository)

        model.updateQuery("cancel")
        let task = Task { await model.load() }
        await repository.waitForRequest("cancel")
        task.cancel()
        await repository.succeed("cancel", results: [sample(id: "late")])
        await task.value

        #expect(model.conversations.isEmpty)
    }

    private func sample(id: String) -> Conversation {
        Conversation(id: id, participant: "Test", preview: "Text", lastActivity: Date(timeIntervalSince1970: 0))
    }
}
