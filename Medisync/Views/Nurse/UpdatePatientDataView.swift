//  UpdatePatientDataView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct UpdatePatientDataView: View {
    @ObservedObject var viewModel: NurseDashboardViewModel
    @State private var showingAddPatientForm = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    if viewModel.patients.isEmpty {
                        Text("No patients available. Please add some.")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.patients) { patient in
                                    NavigationLink(destination: PatientDetailView(patient: patient)) {
                                        PatientCard(patient: patient)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                    }

                    Spacer()

                    Button(action: {
                        showingAddPatientForm = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Patient")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                        .cornerRadius(15)
                        .padding(.top, 20)
                    }
                    .padding()
                    .sheet(isPresented: $showingAddPatientForm) {
                        AddPatientForm(viewModel: viewModel)
                            .background(
                                LinearGradient(
                                    colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .ignoresSafeArea()
                    }
                }
                .padding()
            }
            .navigationTitle("Update Patient Data")
            .foregroundColor(.white)
        }
    }
}


struct PatientCard: View {
    let patient: Patient
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(patient.name)
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Text("Age: \(patient.age)")
                    .foregroundColor(.white.opacity(0.7))
                Text("Blood Type: \(patient.bloodType)")
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }
}
