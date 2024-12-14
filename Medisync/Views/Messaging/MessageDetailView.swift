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
            Text("Message from \(message.sender)")
                .font(.title)
            Text(message.subject)
            Text(message.content)
            Text("Sent at \(message.timestamp)")
        }
        .navigationTitle("Message Details")
    }
}

