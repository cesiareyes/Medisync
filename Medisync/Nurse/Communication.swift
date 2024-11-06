//
//  Communication.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/6/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Communication: View {
    @State var patientData: [Patient] = []
    @State var showAddPatient = false
    @State var showPatientDetails = false
    @State var patientDetails: Patient?
    @State var showPatientProfile = false
    @State var patientProfile: Patient?
    @State var showPatientProfileDetails = false
    @State var patientProfileDetails: Patient?
    @State private var showDoctorMessages = false
    @State private var showLabTechMessages = false
    
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
                            Button(action: {
                                self.showDoctorMessages.toggle()
                            }) {
                                Image(systemName: "message")
                                    .font(.title)
                            }
                            Button(action: {
                                self.showLabTechMessages.toggle()
                            }) {
                                Image(systemName: "message")
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
                })
                .sheet(isPresented: $showAddPatient) {
                    AddPatientView(patientData: $patientData)
                }
                .sheet(isPresented: $showPatientDetails) {
                    PatientDetailsView(patient: $patientDetails, patientData: $patientData)
                }
                .sheet(isPresented: $showDoctorMessages) {
                    DoctorMessagesView()
                }
                .sheet(isPresented: $showLabTechMessages) {
                    LabTechMessagesView()
                }
            }
        }
        .onAppear {
            fetchPatientData()
        }
    }
}
