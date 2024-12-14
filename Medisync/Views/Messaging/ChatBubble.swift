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
                Spacer()
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
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: isSentByCurrentUser ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
    
    private func formattedTimestamp(_ timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: timestamp)
    }
}

