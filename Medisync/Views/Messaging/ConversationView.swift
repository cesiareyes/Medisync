//
//  ConversationView.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/12/24.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var messagesViewModel: MessagesViewModel
    var messages: [Message]
    var currentUserName: String
    @Binding var messageContent: String
    var selectedReceiver: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Conversation with \(selectedReceiver)")
                    .font(.headline)
                    .padding(.top)
                Spacer()
            }
            .padding()
            
            // Display conversation messages for the selected receiver
            ScrollView {
                ForEach(filteredMessages(messages: messages), id: \.id) { message in
                    ChatBubble(message: message, isSentByCurrentUser: message.sender == currentUserName)
                }
            }
            .padding()
            
            // Message input field
            MessageInputView(
                messageContent: $messageContent,  // Only bind messageContent
                sendMessage: {
                    let sender = currentUserName
                    let receiver = selectedReceiver
                    let content = messageContent
                    let subject = "General" // Use a default subject
                    // Call sendMessage with the default subject
                    messagesViewModel.sendMessage(from: sender, to: receiver, subject: subject, content: content)
                }
            )
        }
    }
    
    // Filter messages by the selected receiver
    private func filteredMessages(messages: [Message]) -> [Message] {
        return messages.filter {
            ($0.sender == selectedReceiver && $0.receiver == currentUserName) ||
            ($0.receiver == selectedReceiver && $0.sender == currentUserName)
        }
    }
}
