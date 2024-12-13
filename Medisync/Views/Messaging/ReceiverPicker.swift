//
//  ReceiverPicker.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/12/24.
//

import SwiftUI

struct ReceiverPicker: View {
    @Binding var selectedReceiver: String? // Binding to hold the selected receiver's name
    var availableUsers: [User] // Array of User objects

    var body: some View {
        Picker("Select Receiver", selection: $selectedReceiver) {
            ForEach(availableUsers, id: \.uid) { user in
                Text(user.name).tag(user.name as String?)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
    }
}





