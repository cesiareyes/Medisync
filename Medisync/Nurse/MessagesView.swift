//
//  MessagesView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var viewModel: NurseDashboardViewModel
    
    var body: some View {
        VStack {
            if viewModel.messages.isEmpty {
                Text("No messages to display.")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.messages) { message in
                    NavigationLink(destination: MessageDetailView(message: message)) {
                        Text(message.content)
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: .infinity)
            }
        }
        
    }
}
