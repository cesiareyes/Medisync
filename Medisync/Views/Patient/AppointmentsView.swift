//
//  AppointmentsView.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/7/24.
//

import SwiftUI

struct AppointmentsView: View {
    @ObservedObject var viewModel: PatientDashboardViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(viewModel.appointments) { appointment in
                    AppointmentCard(appointment: appointment)
                }
            }
            .padding()
        }
    }
}

struct AppointmentCard: View {
    let appointment: Appointment

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(appointment.doctorName)
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Text("\(appointment.date, style: .date), \(appointment.time, style: .time)")
                    .foregroundColor(.white.opacity(0.7))
                Text(appointment.status.rawValue.capitalized)
                    .foregroundColor(statusColor(for: appointment.status))
                    .font(.footnote).bold()
            }
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }

    private func statusColor(for status: AppointmentStatus) -> Color {
        switch status {
        case .pending: return .yellow
        case .confirmed: return .green
        case .completed: return .blue
        case .canceled: return .red
        }
    }
}


#Preview {
    AppointmentsView(viewModel: PatientDashboardViewModel())
}
