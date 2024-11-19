//
//  UpdatePatientDataView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct UpdatePatientDataView: View {
    @ObservedObject var viewModel: NurseDashboardViewModel
    
    var body: some View {
        List(viewModel.patients) { patient in
            NavigationLink(destination: PatientDetailView(patient: patient)) {
                Text(patient.name)
            }
        }
        .navigationTitle("Update Patient Data")
    }
}


            
