//
//  LabTechModel.swift
//  Medisync
//
//  Created by Karai Arnold on 11/19/24.
//

import Foundation

struct Inbox: Identifiable{
    let id: String
    let request: String
    let date: Date
    let time: Date
    let status: WaitingStatus
    
}

enum WaitingStatus: String, CaseIterable {
    case canceled, pending, ongoing, completed
}


class LabTechDashboardViewModel: ObservableObject{
    @Published var LabRequests: [Inbox] = [
        Inbox(id: "1", request: "Dr. Smith", date: Date(), time: Date().addingTimeInterval(2500), status: .pending),
        Inbox(id: "2", request: "Dr Noland", date: Date(), time: Date().addingTimeInterval(5500), status: .ongoing)]
}

func fetchLabrequest(){ }
func fetchMedicalrecords() { }



class PendingInbox: ObservableObject {
    @Published var inboxCount: Int = 0
    @Published var pendingRequest: Bool = false
    @Published var userPosition: Int? = nil

    func checkInUser() {
        if !pendingRequest {
            inboxCount += 1
            userPosition = inboxCount
            pendingRequest = true
        }
    }
    
    func nextInQueue() {
        if userPosition != nil {
            inboxCount -= 1
            userPosition = nil
            pendingRequest = false
        }
    }
}
