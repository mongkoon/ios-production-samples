import SwiftUI

struct ConversationListView: View {
    private let repository: any ConversationRepository
    @State private var model: ConversationListModel
    @State private var searchText = ""

    init(repository: any ConversationRepository) {
        self.repository = repository
        _model = State(initialValue: ConversationListModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Group {
                if case .failed(let reason) = model.state, model.conversations.isEmpty {
                    ContentUnavailableView {
                        Label("Unable to Load", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(reason)
                    } actions: {
                        Button("Try Again") { Task { await model.load() } }
                    }
                } else if (model.state == .idle || model.state == .loading) && model.conversations.isEmpty {
                    ProgressView("Loading messages…")
                } else if model.conversations.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List(model.conversations) { conversation in
                        NavigationLink {
                            ConversationDetailView(conversation: conversation, repository: repository)
                        } label: {
                            ConversationRow(conversation: conversation)
                        }
                    }
                    .listStyle(.plain)
                    .overlay(alignment: .top) {
                        if model.state == .loading {
                            ProgressView().controlSize(.mini).padding(8)
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .searchable(text: $searchText, prompt: "Search conversations")
            .onChange(of: searchText) { _, newText in
                model.updateQuery(newText)
            }
            .task(id: searchText) {
                // SwiftUI cancels the previous task when the query changes.
                // The model's epoch check is an additional safeguard.
                do {
                    if !searchText.isEmpty {
                        try await Task.sleep(for: .milliseconds(250))
                    }
                } catch {
                    return
                }
                guard !Task.isCancelled else { return }
                await model.load()
            }
        }
    }
}

private struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color.accentColor.opacity(0.15))
                Text(initials)
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 52, height: 52)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline) {
                    Text(conversation.participant).font(.headline)
                    Spacer(minLength: 6)
                    Text(conversation.lastActivity, style: .date)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text(conversation.preview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    Spacer(minLength: 4)
                    if conversation.unreadCount > 0 {
                        Text(conversation.unreadCount, format: .number)
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .frame(minWidth: 22, minHeight: 22)
                            .background(Color.accentColor, in: Circle())
                            .accessibilityLabel("\(conversation.unreadCount) unread messages")
                    }
                }
            }
        }
        .padding(.vertical, 7)
        .accessibilityElement(children: .combine)
    }

    private var initials: String {
        conversation.participant.split(separator: " ").prefix(2)
            .map { String($0.prefix(1)) }.joined()
    }
}
