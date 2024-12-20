//
//  MessagesListView.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/12/24.
//

import SwiftUI

struct MessagesListView: View {
    var messages: [Message]
    var currentUserName: String
    @Binding var selectedReceiver: String?

    var body: some View {
        VStack {
            // group messages by the receiver
            ForEach(Array(groupMessagesByReceiver(messages: messages).keys), id: \.self) { receiver in
                let messagesForReceiver = groupMessagesByReceiver(messages: messages)[receiver] ?? []
                
                Button(action: {
                    selectedReceiver = receiver  // select the conversation
                }) {
                    HStack {
                        Text(receiver) // display the receiver name as conversation title
                            .font(.headline)
                        Spacer()
                        Text("\(messagesForReceiver.count) messages")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
        }
        .padding()
    }

    private func groupMessagesByReceiver(messages: [Message]) -> [String: [Message]] {
        var groupedMessages = [String: [Message]]()
        
        for message in messages {
            // get the other person in the conversation
            let receiver = message.receiver == currentUserName ? message.sender : message.receiver
            
            // add the message to the correct group (receiver)
            if groupedMessages[receiver] == nil {
                groupedMessages[receiver] = []
            }
            groupedMessages[receiver]?.append(message)
        }
        
        return groupedMessages
    }
}
