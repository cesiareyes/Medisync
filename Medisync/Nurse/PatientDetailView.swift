//
//  PatientDetailView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct PatientDetailView: View {
    var patient: Patient
    
    var body: some View {
        VStack {
            Text("Patient Details for \(patient.name)")
            Text("Age: \(patient.age)")
            Text("Blood Type: \(patient.bloodType)")
            Text("Height: \(patient.height)")
            Text("Weight: \(patient.weight)")
            // Add more patient details here
            
            Spacer()
            
            Button("Update Patient Data") {
                // Add UI elements for updating patient data
                
            }
            .navigationTitle("Patient Details")
        }
    }
}


        
