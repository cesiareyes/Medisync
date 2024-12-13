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
    @Published var availableUsers: [User] = [] // Store available users to select from
    @Published var currentUserName: String = ""
    @Published var selectedReceiver: String? = nil 
    
    private let db = Firestore.firestore()

    // Fetch Nurse, Doctor, and LabTech users
    func fetchUsers() {
        Task {
            do {
                // Fetch users where the role is either "nurse", "doctor" or "labTech"
                let snapshot = try await db.collection("users")
                    .whereField("role", in: ["doctor", "nurse", "labTech"])
                    .getDocuments()
                
                // Process the fetched documents
                let users = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let uid = document.documentID // Document ID is the UID
                    let name = data["name"] as? String ?? "Unknown"
                    let role = data["role"] as? String ?? "Unknown"
                    
                    // Create User model
                    return User(uid: uid, name: name, role: role)
                }
                
                // Update the availableUsers array on the main thread
                DispatchQueue.main.async {
                    self.availableUsers = users
                    print("Available Users: \(self.availableUsers)")
                }
                
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    // Fetch messages for the logged-in user    
    func fetchMessages() {
        guard let currentUserUID = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            print("No logged-in user")
            return
        }
        
        let messagesRef = db.collection("messages").whereField("receiverUID", isEqualTo: currentUserUID)
        
        messagesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching messages: \(error)")
                return
            }
            
            self.messages = snapshot?.documents.compactMap { document in
                let data = document.data()
                return Message(
                    id: document.documentID,
                    sender: data["sender"] as? String ?? "Unknown Sender",
                    receiver: data["receiver"] as? String ?? "Unknown Receiver",
                    content: data["content"] as? String ?? "No Content",
                    subject: data["subject"] as? String ?? "No Subject",
                    timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                )
            } ?? []
            
            print("Messages fetched: \(self.messages.count)")
        }
        
    }

    
    // Send message
    func sendMessage(from sender: String, to receiver: String, subject: String, content: String) {
        guard !sender.isEmpty, !receiver.isEmpty else {
            print("Sender or receiver cannot be empty")
            return
        }
        
        // Get the current authenticated user's UID
        guard let senderUID = FirebaseAuth.Auth.auth().currentUser?.uid else {
            print("Sender UID not found")
            return
        }
        
        // Ensure that the receiver's UID is fetched correctly from availableUsers list
        guard let receiverUID = availableUsers.first(where: { $0.name == receiver })?.uid else {
            print("Receiver UID not found for receiver: \(receiver)")
            return
        }

        // Prepare the message data, including sender and receiver UIDs
        let messageData: [String: Any] = [
            "sender": sender,  // Use the senderName retrieved from FirebaseAuth
            "receiver": receiver,
            "content": content,
            "subject": subject,
            "timestamp": FieldValue.serverTimestamp(),
            "senderUID": senderUID,
            "receiverUID": receiverUID // Include receiver UID
        ]
        
        // Add the message to Firestore
        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                print("Message sent successfully")
            }
        }
    }
}
