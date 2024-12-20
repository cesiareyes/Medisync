//
//  MessagesViewModel.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/10/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct User: Codable {
    var uid: String
    var name: String
    var role: String
}

class MessagesViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var availableUsers: [User] = []
    @Published var currentUserName: String = ""
    @Published var selectedReceiver: String? = nil
    private var messageListener: ListenerRegistration?
    
    private let db = Firestore.firestore()

    func fetchUsers() {
        Task {
            do {
                // fetch users where the role is either "nurse", "doctor" or "labTech"
                let snapshot = try await db.collection("users")
                    .whereField("role", in: ["doctor", "nurse", "labTech"])
                    .getDocuments()
                
                // process the fetched documents
                let users = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let uid = document.documentID // Document ID is the UID
                    let name = data["name"] as? String ?? "Unknown"
                    let role = data["role"] as? String ?? "Unknown"
                    
                    // create user model
                    return User(uid: uid, name: name, role: role)
                }
                
                // update the availableUsers array on the main thread
                DispatchQueue.main.async {
                    self.availableUsers = users
                    print("Available Users: \(self.availableUsers)")
                }
                
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    // fetch messages for the logged-in user
    func fetchMessages() {
        // remove the previous listener to avoid multiple listeners
        messageListener?.remove()
        
        guard let currentUserUID = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            print("No logged-in user")
            return
        }
        
        let messagesRef = db.collection("messages").whereField("receiverUID", isEqualTo: currentUserUID)
        
        messageListener = messagesRef.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching messages: \(error.localizedDescription)")
                return
            }
            
            var newMessages: [String: Message] = [:]
            
            snapshot?.documentChanges.forEach { change in
                let data = change.document.data()
                
                let message = Message(
                    id: change.document.documentID,
                    sender: data["sender"] as? String ?? "Unknown Sender",
                    receiver: data["receiver"] as? String ?? "Unknown Receiver",
                    content: data["content"] as? String ?? "No Content",
                    subject: data["subject"] as? String ?? "No Subject",
                    timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                )
                
                switch change.type {
                case .added:
                    newMessages[message.id] = message
                    
                case .modified:
                    newMessages[message.id] = message
                    
                case .removed:
                    if let index = self.messages.firstIndex(where: { $0.id == message.id }) {
                        self.messages.remove(at: index)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.messages.append(contentsOf: newMessages.values.filter { !self.messages.contains($0) })
                
                self.messages.sort { $0.timestamp > $1.timestamp }
                
                print("Real-time Messages fetched: \(self.messages.count)")
            }
        }
    }



    
    // send message
    func sendMessage(from sender: String, to receiver: String, subject: String, content: String) {
        guard !sender.isEmpty, !receiver.isEmpty else {
            print("Sender or receiver cannot be empty")
            return
        }
        
        // get the current authenticated user's UID
        guard let senderUID = FirebaseAuth.Auth.auth().currentUser?.uid else {
            print("Sender UID not found")
            return
        }
        
        // ensure that the receiver's UID is fetched correctly from availableUsers list
        guard let receiverUID = availableUsers.first(where: { $0.name == receiver })?.uid else {
            print("Receiver UID not found for receiver: \(receiver)")
            return
        }

        // prepare the message data, including sender and receiver UIDs
        let messageData: [String: Any] = [
            "sender": sender,
            "receiver": receiver,
            "content": content,
            "subject": subject,
            "timestamp": FieldValue.serverTimestamp(),
            "senderUID": senderUID,
            "receiverUID": receiverUID
        ]
        
        // add the message to Firestore
        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                print("Message sent successfully")
            }
        }
    }
}
