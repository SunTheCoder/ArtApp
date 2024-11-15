import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    let artPieceID: Int
    @StateObject var userManager: UserManager // Add userManager as a parameter

    @State private var newMessage = ""
    @State private var messages = [Message]()
    @Namespace private var animationNamespace
    private let db = Firestore.firestore()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            MessageView(
                                message: message,
                                isAdmin: isAdmin,
                                dateFormatter: dateFormatter,
                                deleteAction: {
                                    if let messageID = message.id {
                                        deleteMessage(messageID: messageID)
                                    }
                                }
                            )
                            .id(message.id)
                        }

                    }
                    .padding()
                }
                .onChange(of: messages) { oldMessages, newMessages in
                    scrollToBottom(proxy: scrollViewProxy)
                }

                
                HStack {
                    TextField("Enter message...", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        sendMessage()
                        if let lastMessageID = messages.last?.id {
                            withAnimation {
                                scrollViewProxy.scrollTo(lastMessageID, anchor: .bottom)
                            }
                        }
                    }) {
                        Text("Send")
                            .bold()
                            .padding(.horizontal)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
        }
        .onAppear(perform: loadMessages)
    }

    func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }

    func sendMessage() {
        guard let currentUser = userManager.currentUser else { return }
        let username = currentUser.displayName ?? "Anonymous" // Now uses the displayName from Firebase Auth
        let filteredMessage = filterMessage(newMessage)
        
        let messageData: [String: Any] = [
            "text": filteredMessage,
            "timestamp": Timestamp(),
            "artPieceID": artPieceID,
            "username": username
        ]
        
        db.collection("chats")
            .document("\(artPieceID)")
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    print("Message sent")
                    newMessage = ""
                    
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
    }



    func loadMessages() {
        db.collection("chats")
            .document("\(artPieceID)")
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error loading messages: \(error.localizedDescription)")
                    return
                }
                
                self.messages = snapshot?.documents.compactMap { document in
                    do {
                        return try document.data(as: Message.self)
                    } catch {
                        print("Failed to decode message: \(error)")
                        return nil
                    }
                } ?? []
            }
    }

    func filterMessage(_ message: String) -> String {
        let bannedWords = ["nigger", "nigga", "fuck", "shit", "bitch", "ho", "whore", "dick", "pussy", "wetback", "hoe", "dumbass", "dumbazz", "faggot", "gay", "ghey", "betch", "spick", "retard", "retarded", "cracker", "cracka"]
        var filteredMessage = message
        for word in bannedWords {
            filteredMessage = filteredMessage.replacingOccurrences(of: word, with: "****")
        }
        return filteredMessage
    }

    func deleteMessage(messageID: String) {
        db.collection("chats")
            .document("\(artPieceID)")
            .collection("messages")
            .document(messageID)
            .delete { error in
                if let error = error {
                    print("Error deleting message: \(error.localizedDescription)")
                } else {
                    print("Message deleted")
                }
            }
    }

    private var isAdmin: Bool {
        // Replace with actual admin check logic
        return true // Temporary value; adjust based on your authentication logic
    }
}
