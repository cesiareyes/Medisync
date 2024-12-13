//
//  PatientDashboard.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/5/24.
//

import SwiftUI

struct PatientDashboard: View {
    @StateObject private var viewModel = PatientDashboardViewModel()
    @StateObject private var queueManager = QueueManager()
    @State private var selectedTab: Int = 0
    @State private var userName: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Display content based on selected tab
                    if selectedTab == 0 {
                        //Display Welcome Message with User's Name
                        Text("Welcome, \(userName)")
                            .font(.system(size: 28, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .padding(.top, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        AppointmentsView(viewModel: viewModel)
                    } else if selectedTab == 1 {
                        PatientWelcomeView()
                        MedicalRecordsView(viewModel: viewModel)
                            .padding(.top, 10)
                    } else if selectedTab == 2 {
                        PatientWelcomeView()
                        SymptomsView(viewModel: viewModel)
                    } else if selectedTab == 3 {
                        PatientWelcomeView()
                        CheckInView(queueManager: queueManager)
                    }else if selectedTab == 4 {
                        Profile()
                    }
                    
                    Spacer()
                    
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
                        Spacer()
                        
                        TabBarItem(icon: "person.crop.circle", label: "Settings", isSelected:
                                    selectedTab == 4)
                        .onTapGesture { selectedTab = 4}
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                AuthenticationManager.shared.fetchUserName{ name in
                    if let name = name {
                        self.userName = name
                    } else {
                        print("Could not retrieve user name.")
                    }
                }
            }
        }
    }
}

struct PatientWelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                    
            Text("Nurse Dashboard")
                .font(.system(size: 35, weight: .semibold, design: .default))
                .foregroundColor(.black)
                .padding(.top, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
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
