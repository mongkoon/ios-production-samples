import SwiftUI

struct ConversationDetailView: View {
    let conversation: Conversation
    @State private var model: ConversationDetailModel

    init(conversation: Conversation, repository: any ConversationRepository) {
        self.conversation = conversation
        _model = State(initialValue: ConversationDetailModel(conversationID: conversation.id, repository: repository))
    }

    var body: some View {
        Group {
            if case .failed(let reason) = model.state {
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(reason)
                } actions: {
                    Button("Try Again") { Task { await model.load() } }
                }
            } else if model.state == .loading && model.messages.isEmpty {
                ProgressView("Loading conversation…")
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 14) {
                        ForEach(model.messages) { message in
                            HStack {
                                if message.isOutgoing { Spacer(minLength: 60) }
                                Text(message.body)
                                    .font(.body)
                                    .foregroundStyle(message.isOutgoing ? Color.white : Color.primary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 11)
                                    .background(
                                        message.isOutgoing ? Color.accentColor : Color(uiColor: .secondarySystemBackground),
                                        in: RoundedRectangle(cornerRadius: 18)
                                    )
                                if !message.isOutgoing { Spacer(minLength: 60) }
                            }
                            .accessibilityLabel("\(message.isOutgoing ? "You" : conversation.participant): \(message.body)")
                        }
                    }
                    .padding()
                }
                .defaultScrollAnchor(.bottom)
            }
        }
        .navigationTitle(conversation.participant)
        .navigationBarTitleDisplayMode(.inline)
        .task { await model.load() }
    }
}
