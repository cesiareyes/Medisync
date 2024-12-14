//
//  Appointment.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/13/24.
//

import Foundation
import FirebaseFirestore

struct Appointment: Identifiable, Codable {
    var id: String?
    var doctorName: String
    var userId: String
    var date: Date
    var time: Date
    var status: AppointmentStatus
}

enum AppointmentStatus: String, Codable {
    case scheduled
    case completed
    case canceled
}
