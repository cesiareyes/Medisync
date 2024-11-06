//
//  AnalyticalDataAccess.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/6/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AnalyticalDataAccess: View {
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
                })
            }
        }
    }
}
