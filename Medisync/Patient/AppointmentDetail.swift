//
//  AppointmentDetail.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/5/24.
//

import SwiftUI

struct AppointmentDetail: View {
    let appointment: Appointment
    
    var body: some View {
        VStack {
                    Text("Appointment Details")
                        .font(.title)
                        .padding()

                    Text("Doctor: \(appointment.doctorName)")
                    Text("Date: \(appointment.date, style: .date)")
                    Text("Time: \(appointment.time, style: .time)")
                    Text("Status: \(appointment.status.rawValue.capitalized)")

                    // Add more details as needed, e.g., appointment notes, location, etc.
                }
                .padding()
    }
}

#Preview {
    // Create a mock Appointment to pass to AppointmentDetail
    let mockAppointment = Appointment(id: "1", doctorName: "Dr. Smith", date: Date(), time: Date().addingTimeInterval(3600), status: .confirmed)
    
    // Pass the mockAppointment to the AppointmentDetail view
    AppointmentDetail(appointment: mockAppointment)
}

