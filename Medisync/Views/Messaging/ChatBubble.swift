//
//  ChatBubbleView.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/12/24.
//

import SwiftUI

struct ChatBubble: View {
    var message: Message
    var isSentByCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isSentByCurrentUser {
                Spacer() // Push bubble to the right
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.sender)
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Text(message.content)
                    .padding(10)
                    .foregroundColor(isSentByCurrentUser ? .white : .black)
                    .background(isSentByCurrentUser ? Color.purple : Color(.systemGray6))
                    .cornerRadius(20)
                Text(formattedTimestamp(message.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if !isSentByCurrentUser {
                Spacer() // Push bubble to the left
            }
        }
        .frame(maxWidth: .infinity, alignment: isSentByCurrentUser ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
    
    private func formattedTimestamp(_ timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // Change to your preferred format
        return formatter.string(from: timestamp)
    }
}

#Preview {
    ChatBubble(
            message: Message(
                id: "123",
                sender: "John Doe",
                receiver: "Jane Smith",
                content: "Hello, this is a test message.",
                subject: "Test",
                timestamp: Date()
            ),
            isSentByCurrentUser: true // or false depending on what you want to preview
        )
}
