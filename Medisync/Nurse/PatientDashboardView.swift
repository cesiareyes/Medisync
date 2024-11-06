//
//  PatientDashboardView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/6/24.
//

import SwiftUI

struct Patient: Identifiable, Codable {
    var id: String
    var name: String
    var age: String
}

struct PatientDashboardView: View {
    @State var patientData: [Patient] = []
    @State var showAddPatient = false
    @State var showPatientDetails = false
    @State var patientDetails: Patient?
    @State var showPatientProfile = false
    @State var patientProfile: Patient?
    @State var showPatientProfileDetails = false
    @State var patientProfileDetails: Patient?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(patientData) { patient in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(patient.name)
                                    .font(.headline)
                                Text(patient.age)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button(action: {
                                self.patientDetails = patient
                                self.showPatientDetails.toggle()
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.title)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Patients")
                .navigationBarItems(trailing:
                                        Button(action: {
                    self.showAddPatient.toggle()
                }) {
                    Image(systemName: "plus")
                }
                )
                .sheet(isPresented: $showAddPatient) {
                    AddPatientView(patientData: $patientData)
                }
                .sheet(isPresented: $showPatientDetails) {
                    PatientDetailsView(patient: $patientDetails, patientData: $patientData)
                }
            }
        }
        .onAppear {
            fetchPatientData()
        }
    }
    
    func fetchPatientData() {
        if let url = Bundle.main.url(forResource: "patients", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                patientData = try decoder.decode([Patient].self, from: data)
            } catch {
                print("Error loading JSON data: \(error)")
            }
        }
    }
}
