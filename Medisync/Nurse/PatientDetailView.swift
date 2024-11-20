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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Patient Details for \(patient.name)")
                    .font(.title2)
                    .bold()
                
                Text("Age: \(patient.age)")
                Text("Blood Type: \(patient.bloodType)")
                Text("Height: \(patient.height) in")
                Text("Weight: \(patient.weight) lbs")
                
                Text("Symptoms:")
                    .font(.headline)
                Text(patient.symptoms.map {
                    $0.symptom.rawValue
                }.joined(separator: ", "))
                .foregroundColor(.black)
                
                Text("Medications:")
                    .font(.headline)
                Text(patient.medications)
                
                Text("Immunization History:")
                    .font(.headline)
                Text(patient.immunizations)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
        }
    }
}







