//
//  PatientModels.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// enum for different type of medical records
enum RecordType: String, CaseIterable {
    case labResult, prescription, imaging, other
}

//struct representing medical record
struct MedicalRecord: Identifiable {
    let id: String
    let type: RecordType
    let fileURL: URL
    let date: Date
}

//enum for possible symptoms
enum Symptom: String, CaseIterable, Hashable {
    case fever, cough, headache, fatigue, nausea, dizziness, chestPain
    case other
}

// struct to represent details of a symptom
struct SymptomDetail: Hashable {
    var symptom: Symptom
    var duration: String
    var description: String
}

// model for managing patient dashboard data
class PatientDashboardViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var medicalRecords: [MedicalRecord] = []
    @Published var symptoms: [Symptom] = [.fever, .headache]
    @Published var currentUserID: String?
    @Published var doctorsList: [String] = []
    
    let db = Firestore.firestore()
    
    init() {
        fetchAppointments()
        fetchDoctors()
    }
    
    // save appointment to Firestore
    func createAppointment(appointment: Appointment) {
        guard let id = appointment.id else {
            print("Error: Appointment ID is nil.")
            return
        }
        
        // ensure theres an authenticated user
        guard let currentUserId = Auth.auth().currentUser?.uid else {
                print("Error: No authenticated user.")
                return
            }
        
        //data to be saved for appointment
        let appointmentData: [String: Any] = [
            "doctorName": appointment.doctorName,
            "userId": currentUserId,
            "date": Timestamp(date: appointment.date),
            "time": Timestamp(date: appointment.time),
            "status": appointment.status.rawValue
        ]

        // save appointment to firestore
        db.collection("appointments").document(id).setData(appointmentData) { [weak self] error in
            if let error = error {
                print("Error saving appointment: \(error.localizedDescription)")
            } else {
                print("Appointment successfully saved!")
                self?.appointments.append(appointment) // add to list of appointments
            }
        }
    }

    // fetch appointments based on current authenticated user
    func fetchAppointments() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }
        
        let userId = currentUser.uid  // get the current user's ID
        
        db.collection("appointments")
            .whereField("userId", isEqualTo: userId)  // fetch appointments for this user
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching appointments: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No appointments found.")
                    return
                }
                
                self?.appointments = snapshot.documents.compactMap { document in
                    let data = document.data()
                    
                    print("Raw data for document \(document.documentID): \(data)")
                    guard
                        let doctorName = data["doctorName"] as? String,
                        let userId = data["userId"] as? String,
                        let dateTimestamp = data["date"] as? Timestamp,
                        let timeTimestamp = data["time"] as? Timestamp,
                        let statusRaw = data["status"] as? String,
                        let status = AppointmentStatus(rawValue: statusRaw)
                    else {
                        print("Error decoding appointment data for document: \(document.documentID)")
                        return nil
                    }
                    
                    //create an appointment object
                    let appointment = Appointment(
                        id: document.documentID,
                        doctorName: doctorName,
                        userId: userId,
                        date: dateTimestamp.dateValue(),
                        time: timeTimestamp.dateValue(),
                        status: status
                    )
                    return appointment
                }
            }
    }
    
    // fetch list of doctors from Firestore
    private func fetchDoctors() {
        db.collection("users")
            .whereField("role", isEqualTo: "doctor")
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching doctors: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No doctors found.")
                    return
                }
                
                // get doctor names from the documents
                self?.doctorsList = snapshot.documents.compactMap { document in
                    document.data()["name"] as? String
                }
            }
    }
    
    // cancel an appointmentby updating the status
    func cancelAppointment(appointmentId: String) {
        db.collection("appointments").document(appointmentId).updateData([
            "status": AppointmentStatus.canceled.rawValue
        ]) { [weak self] error in
            if let error = error {
                print("Error canceling appointment: \(error.localizedDescription)")
            } else {
                print("Appointment canceled successfully!")
                // update list of appointments
                if let index = self?.appointments.firstIndex(where: { $0.id == appointmentId }) {
                    self?.appointments[index].status = .canceled
                }
            }
        }
    }
    
    // reschedule appointment by updating the status
    func rescheduleAppointment(appointmentId: String, newDate: Date, newTime: Date) {
        db.collection("appointments").document(appointmentId).updateData([
            "date": Timestamp(date: newDate),
            "time": Timestamp(date: newTime)
        ]) { [weak self] error in
            if let error = error {
                print("Error rescheduling appointment: \(error.localizedDescription)")
            } else {
                print("Appointment rescheduled successfully!")
                if let index = self?.appointments.firstIndex(where: { $0.id == appointmentId }) {
                    self?.appointments[index].date = newDate
                    self?.appointments[index].time = newTime
                }
            }
        }
    }
    
    //fetch current user's ID
    func fetchCurrentUserID() {
            do {
                let authData = try AuthenticationManager.shared.getAuthenticatedUser()
                self.currentUserID = authData.uid
            } catch {
                print("Error fetching current user ID: \(error.localizedDescription)")
            }
        }
    
    // log a symptom
    func logSymptom(symptom: SymptomDetail) {
        print("Logged Symptom: \(symptom.symptom.rawValue), Duration: \(symptom.duration), Description: \(symptom.description)")
    }

    func uploadMedicalRecord(fileURL: URL, type: RecordType) { }
}

// model for managin queue of patients
class QueueManager: ObservableObject {
    @Published var queueCount: Int = 0
    @Published var userInQueue: Bool = false
    @Published var userPosition: Int? = nil

    // add current user to the queue
    func checkInUser() {
        if !userInQueue {
            queueCount += 1
            userPosition = queueCount
            userInQueue = true
        }
    }
    
    // remove current user from queue
    func nextInQueue() {
        if userPosition != nil {
            queueCount -= 1
            userPosition = nil
            userInQueue = false
        }
    }
}
