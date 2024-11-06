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
            Appointment(id: "2", doctorName: "Dr. Doe", date: Date().addingTimeInterval(86400), time: Date().addingTimeInterval(5400), status: .pending),
            
            Appointment(id: "3", doctorName: "Dr. Noland", date: Date().addingTimeInterval(86400), time: Date().addingTimeInterval(5400), status: .pending)
        ]
    
    
    @Published var medicalRecords: [MedicalRecord] = []
        @Published var symptoms: [Symptom] = [.fever, .headache]

    func fetchAppointments() {
        // Fetch appointments from Firebase Realtime Database or Firestore
    }

    func fetchMedicalRecords() {
        // Fetch medical records from Firebase Storage
    }

    func logSymptom(symptom: Symptom) {
        // Add symptom to the list and save to Firebase
    }

    func uploadMedicalRecord(fileURL: URL, type: RecordType) {
        // Upload medical record to Firebase Storage and update the list
    }

    // ... other functions for booking appointments, checking in, etc.
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

struct PatientDashboard: View {
    @StateObject private var viewModel = PatientDashboardViewModel()
    @StateObject private var queueManager = QueueManager()
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Patient Dashboard")
                        .font(.system(size: 35, weight: .semibold, design: .default)) // Use San Francisco
                        .foregroundColor(.black)
                        
                        
                }
                .padding(.top, 15)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                TabView(selection: $selectedTab) {
                    //Appointments Tab
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.appointments) { appointment in
                                AppointmentCard(appointment: appointment)
                            }
                        }
                        .padding()
                    }
                    .tag(0)
                    
                    //Medical Records Tab
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.medicalRecords) { record in
                                MedicalRecordCard(record: record)
                            }
                            UploadRecordButton()
                        }
                        .padding()
                    }
                    .tag(1)
                    
                    //Symptom Tracker Tab
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(viewModel.symptoms, id: \.self) { symptom in
                                Text(symptom.rawValue.capitalized)
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            AddSymptomButton()
                        }
                        .padding()
                    }
                    .tag(2)
                    
                    //Check in Queue Tab
                    ScrollView {
                        VStack(spacing: 15) {
                            Text("Enter the queue for your appointment.")
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.leading)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                            
                            if queueManager.userInQueue {
                                Text("You are in the queue!")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                    .padding(.top)
                                Text("You are number \(queueManager.userPosition!) in line.")
                                    .font(.title2)
                                    .padding()
                                    .foregroundColor(.black)
                                Text("\(queueManager.queueCount - 1) people ahead of you.")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                            } else {
                                Text("No one is currently in the queue.")
                                    .font(.title3)
                                    .padding(.bottom)
                                    .foregroundColor(.gray)
                            }
                            
                            if !queueManager.userInQueue {
                                Button("Check-In Now") {
                                    queueManager.checkInUser()
                                }
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.8))
                                .cornerRadius(15)
                            } else {
                                Button("Leave Queue") {
                                    queueManager.nextInQueue()
                                }
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(15)
                            }
                        }
                        .padding()
                    }
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                //Tab bar
                HStack {
                    TabBarItem(icon: "calendar", label: "Appointments", isSelected: selectedTab == 0)
                        .onTapGesture { selectedTab = 0 }
                    Spacer()
                    
                    TabBarItem(icon: "doc.text", label: "Records", isSelected: selectedTab == 1)
                        .onTapGesture { selectedTab = 1 }
                    Spacer()
                    
                    TabBarItem(icon: "stethoscope", label: "Symptoms", isSelected: selectedTab == 2)
                        .onTapGesture { selectedTab = 2 }
                    Spacer()
                    
                    TabBarItem(icon: "checkmark.circle", label: "Check-In", isSelected: selectedTab == 3)
                            .onTapGesture { selectedTab = 3 }
                }
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}

struct AppointmentCard: View {
    let appointment: Appointment

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(appointment.doctorName)
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Text("\(appointment.date, style: .date), \(appointment.time, style: .time)")
                    .foregroundColor(.white.opacity(0.7))
                Text(appointment.status.rawValue.capitalized)
                    .foregroundColor(statusColor(for: appointment.status))
                    .font(.footnote).bold()
            }
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }

    func statusColor(for status: AppointmentStatus) -> Color {
        switch status {
        case .pending: return .yellow
        case .confirmed: return .green
        case .completed: return .blue
        case .canceled: return .red
        }
    }
        
}

struct MedicalRecordCard: View {
    let record: MedicalRecord

    var body: some View {
        VStack(alignment: .leading) {
            Text(record.type.rawValue.capitalized)
                .font(.title3).bold()
                .foregroundColor(.white)
            Text("Date: \(record.date, style: .date)")
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }
}

struct UploadRecordButton: View {
    var body: some View {
        Button("Upload Medical Record") {
            //Code to upload medical record here
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
        .cornerRadius(15)
    }
}

struct AddSymptomButton: View {
    var body: some View {
        Button("Add Symptom") {
            //Code to log a new symptom here
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
        .cornerRadius(15)
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    var isSelected: Bool

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isSelected ? .white : .gray)
            Text(label)
                .font(.footnote)
                .foregroundColor(isSelected ? .white : .gray)
        }
    }
}

#Preview {
    PatientDashboard()
}
