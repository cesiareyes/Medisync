import SwiftUI

struct AppointmentsView: View {
    @ObservedObject var viewModel: PatientDashboardViewModel
    @State private var isAddAppointmentPresented: Bool = false

    var body: some View {
        VStack {
            // button to show the Add Appointment form
            Button(action: {
                isAddAppointmentPresented.toggle()
            }) {
                Text("Make a New Appointment")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                    .cornerRadius(15)
            }
            .padding()

            // list of existing appointments
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.appointments) { appointment in
                        AppointmentCard(viewModel: viewModel, appointment: appointment)
                    }
                }
                .padding()
            }
            // show the add appointment modal when the button is tapped
            .sheet(isPresented: $isAddAppointmentPresented) {
                AddAppointmentView(isPresented: $isAddAppointmentPresented, viewModel: viewModel, userId: viewModel.currentUserID ?? "", doctorsList: viewModel.doctorsList)
            }
        }
    }
}


// view to display individual appointment in a card
struct AppointmentCard: View {
    @ObservedObject var viewModel: PatientDashboardViewModel
    let appointment: Appointment
    @State private var isDetailPresented = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // display doctor name
                Text(appointment.doctorName)
                    .font(.title2).bold()
                    .foregroundColor(.white)
                // display appointment status with appropriate color
                Text("\(appointment.date, style: .date), \(appointment.time, style: .time)")
                    .foregroundColor(.white.opacity(0.7))
                Text(appointment.status.rawValue.capitalized)
                    .foregroundColor(statusColor(for: appointment.status))
                    .font(.title3)
                    .bold()
            }
            Spacer()
            
            
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
        //show appointment detail view on tap
        .onTapGesture {
            isDetailPresented.toggle()
        }
        .sheet(isPresented: $isDetailPresented) {
            AppointmentDetailView(viewModel: viewModel, appointment: appointment)
        }
    }

    // return a color based on appointment status
    private func statusColor(for status: AppointmentStatus) -> Color {
        switch status {
        case .scheduled: return .blue
        case .completed: return .green
        case .canceled: return .red
        }
    }
}

// view to create a new appointment
struct AddAppointmentView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PatientDashboardViewModel
    @State private var selectedDoctor: String = ""
    @State private var appointmentDate: Date = Date()
    @State private var appointmentTime: Date = Date()
    var userId: String
    var doctorsList: [String]

    var body: some View {
        NavigationView {
            Form {
                // select doctor
                Section(header: Text("Doctor")) {
                    Picker("Select a Doctor", selection: $selectedDoctor) {
                        ForEach(doctorsList, id: \.self) { doctor in
                            Text(doctor)
                        }
                    }
                }

                // select date
                Section(header: Text("Appointment Date")) {
                    DatePicker("Choose Date", selection: $appointmentDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                //select time
                Section(header: Text("Appointment Time")) {
                    DatePicker("Choose Time", selection: $appointmentTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())  // Use Wheel style for better time selection
                }

                // button to confirm appointment creation
                Section {
                    Button("Create Appointment") {
                        // Add logic for creating appointment here
                        let newAppointment = Appointment(
                            id: UUID().uuidString,
                            doctorName: selectedDoctor,
                            userId: userId,
                            date: appointmentDate,
                            time: appointmentTime,
                            status: .scheduled
                        )
                        viewModel.createAppointment(appointment: newAppointment)  // add the new appointment
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                    .cornerRadius(15)
                }
            }
            .navigationBarTitle("New Appointment", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

// view to display detailed information about an appointment
struct AppointmentDetailView: View {
    @ObservedObject var viewModel: PatientDashboardViewModel
    let appointment: Appointment
    @State private var selectedDate: Date
    @State private var selectedTime: Date
    @State private var showConfirmation = false

    init(viewModel: PatientDashboardViewModel, appointment: Appointment) {
        self.viewModel = viewModel
        self.appointment = appointment
        _selectedDate = State(initialValue: appointment.date)
        _selectedTime = State(initialValue: appointment.time)
    }

    var body: some View {
        NavigationView {
            Form {
                // appointment details
                Section(header: Text("Appointment Details")) {
                    Text("Doctor: \(appointment.doctorName)")
                    Text("Date: \(appointment.date, style: .date)")
                    Text("Time: \(appointment.time, style: .time)")
                    Text("Status: \(appointment.status.rawValue.capitalized)")
                }

                // option to cancel the appointment
                Section {
                    Button(action: {
                        // confirm cancellation
                        showConfirmation.toggle()
                    }) {
                        Text("Cancel Appointment")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .alert(isPresented: $showConfirmation) {
                        Alert(
                            title: Text("Cancel Appointment"),
                            message: Text("Are you sure you want to cancel this appointment?"),
                            primaryButton: .destructive(Text("Cancel Appointment")) {
                                if let appointmentId = appointment.id {
                                    viewModel.cancelAppointment(appointmentId: appointmentId)
                                }
                                
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }

                // option to reschedule the appointment
                Section(header: Text("Reschedule Appointment")) {
                    DatePicker("Choose a new date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    DatePicker("Choose a new time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())

                    Button(action: {
                        if let appointmentId = appointment.id {
                            viewModel.rescheduleAppointment(appointmentId: appointmentId, newDate: selectedDate, newTime: selectedTime)
                        }
                    }) {
                        Text("Reschedule Appointment")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarTitle("Appointment Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                // dismiss the modal
                self.$showConfirmation.wrappedValue = false
            })
        }
    }
}

