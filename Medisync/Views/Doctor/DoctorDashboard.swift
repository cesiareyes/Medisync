//
//  DoctorDashboard.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/18/24.
//

import SwiftUI

struct DoctorDashboard: View {
    @StateObject private var viewModel = DoctorDashboardViewModel()
    @StateObject private var messagesViewModel = MessagesViewModel()
    @State private var selectedTab: Int = 0
    @State private var showingUpdatePatientData = false  // This will control the modal
    @State private var userName: String = ""
    
    var body: some View {
        NavigationStack { // Use NavigationStack to handle navigation
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    if selectedTab == 0 {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome, \(userName)")
                                .font(.system(size: 28, weight: .semibold, design: .default))
                                .foregroundColor(.black)
                                .padding(.top, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        WelcomeView()
                        
                        // **Patient List View**
                        ScrollView {
                            if viewModel.patients.isEmpty {
                                Text("No patients listed.")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(viewModel.patients) { patient in
                                    NavigationLink(destination: PatientDetailView(patient: patient)) {
                                        PatientCard(patient: patient)
                                            .padding(.horizontal)
                                            .padding(.top, 5)
                                    }
                                }
                            }
                        }
                    } else if selectedTab == 1 {
                        WelcomeView()
                        // **Analytical Data View**
                        ScrollView {
                            if viewModel.analyticalData.isEmpty {
                                Text("No analytical data available.")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(viewModel.analyticalData) { data in
                                    Text(data.description)
                                        .font(.title3)
                                        .padding()
                                }
                            }
                        }
                    } else if selectedTab == 2 {
                        Text("Inbox")
                            .font(.system(size: 35, weight: .semibold, design: .default))
                            .foregroundColor(.black)
                            .padding(.top, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        MessagesView(
                            messagesViewModel: messagesViewModel,
                            availableUsers: messagesViewModel.availableUsers
                        )
                        
                    } else if selectedTab == 3 {
                        Profile()
                    }
                    
                    Spacer()

                    // Tab Bar Navigation
                    HStack {
                        DoctorTabBarItem(icon: "person", label: "Patients", isSelected: selectedTab == 0)
                            .onTapGesture { selectedTab = 0 }
                        Spacer()
                        DoctorTabBarItem(icon: "chart.bar", label: "Analytical Data", isSelected: selectedTab == 1)
                            .onTapGesture { selectedTab = 1 }
                        Spacer()
                        DoctorTabBarItem(icon: "message", label: "Messages", isSelected: selectedTab == 2)
                            .onTapGesture { selectedTab = 2 }
                        Spacer()
                        DoctorTabBarItem(icon: "person.crop.circle", label: "Settings", isSelected:
                            selectedTab == 3)
                        .onTapGesture { selectedTab = 3}
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .onAppear {
                viewModel.fetchPatients() // Fetch patients on dashboard load
            }
            .onAppear {
                AuthenticationManager.shared.fetchUserName { name in
                    if let name = name {
                        self.userName = name
                    } else {
                        print("Could not retrieve user name")
                    }
                }
            }

        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingUpdatePatientData) {
            //ComposeMessageView()
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                    
            Text("Doctor Dashboard")
                .font(.system(size: 35, weight: .semibold, design: .default))
                .foregroundColor(.black)
                .padding(.top, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
}

struct DoctorTabBarItem: View {
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
    DoctorDashboard()
}
