import SwiftUI
import FirebaseFirestore


struct ChatView: View {
    let artPieceID: Int
    @State private var newMessage = ""
    @State private var messages = [Message]()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages) { message in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message.text)
                                .padding(4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Display formatted timestamp
                            Text(dateFormatter.string(from: message.timestamp.dateValue()))
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                        }
                    }
                }
            }
            .padding(2)

            HStack {
                TextField("Enter message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) {
                    Text("Send")
                        .bold()
                        .padding(.horizontal)
                }
            }
            .padding(2)
        }
        .onAppear(perform: loadMessages)
    }
    
    func sendMessage() {
        let filteredMessage = filterMessage(newMessage)
        let messageData: [String: Any] = [
            "text": filteredMessage,
            "timestamp": Timestamp(),
            "artPieceID": artPieceID // Ensure artPieceID is of type Int
        ]
        
        // Access the nested `messages` collection under the specific `artPieceID` in `chats`
        Firestore.firestore()
            .collection("chats")
            .document("\(artPieceID)") // Convert `artPieceID` to String if needed
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    print("Message sent")
                    newMessage = ""
                }
            }
    }

    func loadMessages() {
        Firestore.firestore()
            .collection("chats")
            .document("\(artPieceID)")
            .collection("messages")
            .order(by: "timestamp")  // Ensures messages load in correct order
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
        let bannedWords = ["badword1", "badword2"]
        var filteredMessage = message
        for word in bannedWords {
            filteredMessage = filteredMessage.replacingOccurrences(of: word, with: "****")
        }
        return filteredMessage
    }
}
