//
//  PatientModels.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/7/24.
//

import Foundation

struct Appointment: Identifiable {
    let id: String
    let doctorName: String
    let date: Date
    let time: Date
    let status: AppointmentStatus
}

enum AppointmentStatus: String, CaseIterable {
    case pending, confirmed, completed, canceled
}

enum RecordType: String, CaseIterable {
    case labResult, prescription, imaging, other
}

struct MedicalRecord: Identifiable {
    let id: String
    let type: RecordType
    let fileURL: URL
    let date: Date
}

enum Symptom: String, CaseIterable {
    case fever, cough, headache, fatigue, nausea, dizziness, chestPain
}

struct SymptomDetail {
    var symptom: Symptom
    var duration: String
    var description: String
}

class PatientDashboardViewModel: ObservableObject {
    @Published var appointments: [Appointment] = [
        Appointment(id: "1", doctorName: "Dr. Smith", date: Date(), time: Date().addingTimeInterval(3600), status: .confirmed),
        Appointment(id: "2", doctorName: "Dr. Doe", date: Date().addingTimeInterval(86400), time: Date().addingTimeInterval(5400), status: .pending),
        Appointment(id: "3", doctorName: "Dr. Noland", date: Date().addingTimeInterval(86400), time: Date().addingTimeInterval(5400), status: .pending)
    ]
    
    @Published var medicalRecords: [MedicalRecord] = []
    @Published var symptoms: [Symptom] = [.fever, .headache]

    // Fetching and handling methods
    func fetchAppointments() { }
    func fetchMedicalRecords() { }
    
    func logSymptom(symptom: SymptomDetail) {
        print("Logged Symptom: \(symptom.symptom.rawValue), Duration: \(symptom.duration), Description: \(symptom.description)")
    }

    
    func uploadMedicalRecord(fileURL: URL, type: RecordType) { }
}

class QueueManager: ObservableObject {
    @Published var queueCount: Int = 0
    @Published var userInQueue: Bool = false
    @Published var userPosition: Int? = nil

    func checkInUser() {
        if !userInQueue {
            queueCount += 1
            userPosition = queueCount
            userInQueue = true
        }
    }
    
    func nextInQueue() {
        if userPosition != nil {
            queueCount -= 1
            userPosition = nil
            userInQueue = false
        }
    }
}
