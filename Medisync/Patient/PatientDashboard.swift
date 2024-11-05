//
//  PatientDashboard.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/5/24.
//

import SwiftUI

struct Appointment: Identifiable {
    let id: String
    let doctorName: String
    let date: Date
    let time: Date
    // Enum for pending, confirmed, completed
    let status: AppointmentStatus
}

enum AppointmentStatus: String, CaseIterable {
    case pending
    case confirmed
    case completed
    case canceled
}

enum RecordType: String, CaseIterable {
    case labResult
    case prescription
    case imaging
    case other
}

struct MedicalRecord: Identifiable {
    let id: String
    // Enum for lab results, prescriptions, imaging
    let type: RecordType
    let fileURL: URL
    let date: Date
}

enum Symptom: String, CaseIterable {
    case fever, cough, headache
}



class PatientDashboardViewModel: ObservableObject {

    @Published var appointments: [Appointment] = [
            Appointment(id: "1", doctorName: "Dr. Smith", date: Date(), time: Date().addingTimeInterval(3600), status: .confirmed),
            Appointment(id: "2", doctorName: "Dr. Doe", date: Date().addingTimeInterval(86400), time: Date().addingTimeInterval(5400), status: .pending)
        ]
    
    @Published var medicalRecords: [MedicalRecord] = []
        @Published var symptoms: [Symptom] = [.fever, .headache]

    func fetchAppointments() {
        // Fetch appointments from Firebase Realtime Database or Firestore
        // ...
    }

    func fetchMedicalRecords() {
        // Fetch medical records from Firebase Storage
        // ...
    }

    func logSymptom(symptom: Symptom) {
        // Add symptom to the list and save to Firebase
        // ...
    }

    func uploadMedicalRecord(fileURL: URL, type: RecordType) {
        // Upload medical record to Firebase Storage and update the list
        // ...
    }

    // ... other functions for booking appointments, checking in, etc.
}


struct PatientDashboard: View {
    @StateObject private var viewModel = PatientDashboardViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // appointments Section
                Section(header: Text("Appointments")) {
                    ForEach(viewModel.appointments) { appointment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(appointment.doctorName)")
                                    .font(.headline)
                                Text("\(appointment.date, style: .date), \(appointment.time, style: .time)")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(appointment.status.rawValue.capitalized)
                                .foregroundColor(statusColor(for: appointment.status))
                                .font(.footnote)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder())
                        .onTapGesture {
                            // navigate to appointment details
                        }
                    }
                }
                // medical Records Section
                Section(header: Text("Medical Records")) {
                    ForEach(viewModel.medicalRecords) { record in
                        Text(record.type.rawValue.capitalized)
                            .font(.subheadline)
                    }
                    Button("Upload Medical Record") {
                        // Action to upload medical record
                    }
                }
                
                // Symptom Tracker Section
                Section(header: Text("Symptom Tracker")) {
                    ForEach(viewModel.symptoms, id: \.self) { symptom in
                        Text(symptom.rawValue.capitalized)
                    }
                    Button("Add Symptom") {
                        // Action to log a new symptom
                    }
                }
                
                // Check-In Section
                Section {
                    Button(action: {
                        // Code for checking in
                    }) {
                        Text("Check In for Appointment")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Patient Dashboard")
            .listStyle(GroupedListStyle())
            .padding(.top, 20)
        }
    }
    // Helper to get the color for the appointment status
    func statusColor(for status: AppointmentStatus) -> Color {
        switch status {
        case .pending:
            return .yellow
        case .confirmed:
            return .green
        case .completed:
            return .blue
        case .canceled:
            return .red
        }
    }
}

#Preview {
    PatientDashboard()
}
