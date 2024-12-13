//
//  SubjectPicker.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/12/24.
//

import SwiftUI

struct SubjectPicker: View {
    @Binding var messageSubject: String

    var body: some View {
        Picker("Select Subject", selection: $messageSubject) {
            Text("General").tag("General")
            Text("Urgent").tag("Urgent")
            Text("Follow-Up").tag("Follow-Up")
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
    }
}

