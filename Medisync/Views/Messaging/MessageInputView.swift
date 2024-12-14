//
//  MessageInputView.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/12/24.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var messageContent: String
    var sendMessage: () -> Void
    
    var body: some View {
        HStack {
            // message content input
            TextField("Type your message", text: $messageContent)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.circle.fill")
                    .font(.title)
                    .foregroundColor(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                    .padding()
            }
        }
        .padding()
    }
}
