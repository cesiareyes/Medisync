import SwiftUI
import FirebaseAuth

struct NurseDashboard: View {
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
                    TabBarItem(icon: "list.bullet.clipboard", label: "Vitals", isSelected: selectedTab == 0)
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

struct Stuff: View {
    let appointment: Appointment

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("test")
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

struct Stuff4: View {
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

struct Stuff2: View {
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

struct Stuff3: View {
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

struct Stuff5: View {
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
    NurseDashboard()
}
