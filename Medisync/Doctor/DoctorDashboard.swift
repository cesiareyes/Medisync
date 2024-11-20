//
//  DoctorDashboard.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/18/24.
//

import SwiftUI

struct DoctorDashboard: View {
    @StateObject private var viewModel = DoctorDashboardViewModel()
    @State private var selectedTab: Int = 0
    @State private var showingUpdatePatientData = false  // This will control the modal
    
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
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.leading)
                                
                            Text("Welcome, Doctor Strange")
                                .font(.system(size: 30, weight: .semibold, design: .default))
                                .foregroundColor(.black)
                                .padding(.top, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                    }
                    
                    if selectedTab == 0 {
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
}
//                        else if selectedTab == 1 {
//                        AnalyticalDataView(viewModel: viewModel)
//                    } else if selectedTab == 2 {
//                        MessagesView(viewModel: viewModel)
//                    }
                    
                    Spacer()

                    
                    
                    // Tab Bar Navigation
                    HStack {
                        NurseTabBarItem(icon: "person", label: "Patients", isSelected: selectedTab == 0)
                            .onTapGesture { selectedTab = 0 }
                        Spacer()
                        NurseTabBarItem(icon: "chart.bar", label: "Analytical Data", isSelected: selectedTab == 1)
                            .onTapGesture { selectedTab = 1 }
                        Spacer()
                        NurseTabBarItem(icon: "message", label: "Messages", isSelected: selectedTab == 2)
                            .onTapGesture { selectedTab = 2 }
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
