//
//  MedicalRecordsView.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/7/24.
//

import SwiftUI

struct MedicalRecordsView: View {
    @ObservedObject var viewModel: PatientDashboardViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(viewModel.medicalRecords) { record in
                    MedicalRecordCard(record: record)
                }
                UploadRecordButton()
            }
            .padding()
        }
    }
}

struct MedicalRecordCard: View {
    let record: MedicalRecord

    var body: some View {
        VStack(alignment: .leading) {
            Text(record.type.rawValue.capitalized)
                .font(.title3).bold()
                .foregroundColor(.white)
            Text("Date: \(record.date, style: .date)")
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }
}

struct UploadRecordButton: View {
    var body: some View {
        Button("Upload Medical Record") {
            // Code to upload medical record here
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
        .cornerRadius(15)
    }
}


#Preview {
    MedicalRecordsView(viewModel: PatientDashboardViewModel())
}
