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
        List(viewModel.messages) { message in
            NavigationLink(destination: MessageDetailView(message: message)) {
                Text(message.content)
            }
        }
        .navigationTitle("Messages")
    }
}
