//
//  LabInbox.swift
//  Medisync
//
//  Created by Karai Arnold on 11/20/24.
//

import SwiftUI

struct LabInbox: View{
    let labRequest: Inbox
    
    var body: some View{
        VStack{
            
            Text("Pending Request").font(.title).padding()
            
            Text("Doctor: \(labRequest.request)")
            Text("Patient: Elvis Presley")
            Text("Date: \(labRequest.date, style: .date)")
            Text("Time: \(labRequest.time, style: .time)")
            Text("Status: \(labRequest.status.rawValue.capitalized)")
            
            Spacer()
        }
        .padding()
        
    }
    
}

#Preview{
    let practiceInbox = Inbox(id: "1", request: "Dr. Smith", date: Date(), time: Date().addingTimeInterval(5500), status: .pending)
    LabInbox(labRequest: practiceInbox)
}
