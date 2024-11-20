//
//  MessageDetailView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct MessageDetailView: View {
    var message: Message
    
    var body: some View {
        VStack {
            Text("From: \(message.sender)")
            Text("Subject: \(message.subject)")
            Text(message.content)
            
            Spacer()
            
            Button("Reply") {
                //reply logic will be placed here
            }
            .navigationTitle("Message Details")
        }
    }
}
