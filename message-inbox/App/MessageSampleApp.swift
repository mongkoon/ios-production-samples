import SwiftUI

@main
struct MessageSampleApp: App {
    private let repository = DemoConversationRepository()

    var body: some Scene {
        WindowGroup {
            ConversationListView(repository: repository)
        }
    }
}
