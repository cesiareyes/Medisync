//
//  NurseDashboardViewModel.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class NurseDashboardViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var messages: [Message] = []
    @Published var analyticalData: [AnalyticalData] = []
    
    func fetchPatients() {
        guard let nurseUID = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            print("No logged-in nurse")
            return
        }

        let db = Firestore.firestore()
        let patientsRef = db.collection("nurses").document(nurseUID).collection("patients")

        patientsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching patients: \(error)")
                return
            }

            self.patients = snapshot?.documents.compactMap { document in
                let data = document.data()
                return Patient(
                    id: document.documentID,
                    name: data["name"] as? String ?? "",
                    age: data["age"] as? Int ?? 0,
                    bloodType: data["bloodType"] as? String ?? "",
                    height: data["height"] as? Int ?? 0,
                    weight: data["weight"] as? Int ?? 0,
                    symptoms: (data["symptoms"] as? [[String: Any]])?.compactMap { symptomData in
                        guard
                            let symptom = symptomData["symptom"] as? String,
                            let duration = symptomData["duration"] as? String,
                            let description = symptomData["description"] as? String
                        else {
                            return SymptomDetail(symptom: .other, duration: "Unknown", description: "No description available")
                        }
                        return SymptomDetail(symptom: Symptom(rawValue: symptom) ?? .other, duration: duration, description: description)
                    } ?? [],
                    medications: data["medications"] as? String ?? "",
                    immunizations: data["immunizations"] as? String ?? ""
                )
            } ?? []
            print("Patients fetched: \(self.patients.count)") 
        }
    }

    
    func fetchMessages() {
        guard let nurseUID = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            print("No logged-in nurse")
            return
        }
        
        let db = Firestore.firestore()
        let messagesRef = db.collection("nurses").document(nurseUID).collection("messages")
        
        messagesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching messages: \(error)")
                return
            }
            
            self.messages = snapshot?.documents.compactMap { document in
                let data = document.data()
                return Message(
                    id: UUID(uuidString: document.documentID) ?? UUID(),
                    sender: data["sender"] as? String ?? "Unknown",
                    subject: data["subject"] as? String ?? "No subject",
                    content: data["content"] as? String ?? "No content"
                )
            } ?? []
        }
    }
    
    func fetchAnalyticalData() {
        guard let nurseUID = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            print("No logged-in nurse")
            return
        }
        
        let db = Firestore.firestore()
        let analyticalDataRef = db.collection("nurses").document(nurseUID).collection("analyticalData")
        
        analyticalDataRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching analytical data: \(error)")
                return
            }
            
            self.analyticalData = snapshot?.documents.compactMap { document in
                let data = document.data()
                return AnalyticalData(
                    id: UUID(uuidString: document.documentID) ?? UUID(),
                    description: data["description"] as? String ?? "No description"
                )
            } ?? []
        }
    }
}



