//
//  RegistrationView.swift
//  Medisync
//
//  Created by Cesia Reyes on 10/1/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


enum Role: String, CaseIterable {
    case doctor
    case nurse
    case labTech
    case patient
}

/**
 * A class for handling user registration, including storing user data in Firestore and Firebase Authentication.
 * This code was adapted from Two Youtube videos titled
 * "iOS Firebase Authentication: Sign In With Email & Password Tutorial (1/2) | Firebase Bootcamp #3"
 * "iOS Firebase Authentication: Sign In With Email & Password Tutorial (1/2) | Firebase Bootcamp #3"
 * by Swiftful Thinking, published on March 15, 2023
 * https://www.youtube.com/watch?v=4FAuU5Ev-5Y
 * https://www.youtube.com/watch?v=jlC1yjVTMtA&t=138s
 */

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var dateOfBirth = Date()
    @Published var selectedRole: Role? = .patient
    
    func registerUser(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            print("All fields must be filled out")
            return
        }
        
        Task {
            do {
                let user = try await Auth.auth().createUser(withEmail: email, password: password)
                print("Success")
                print(user)
                
                let db = Firestore.firestore()
                // Store additional user data in Firestore
                let userRef = db.collection("users").document(user.user.uid)
                try await userRef.setData([
                    "name": name,
                    "dateOfBirth": dateOfBirth,
                    "role": selectedRole?.rawValue ?? "unknown" // Convert to String
                ])
                
                completion(true)
            } catch {
                print("Error: \(error)")
            }
        }

    }
}


struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var isRegistered = false
    @State private var selectedRole: Role? = nil
    
    var body: some View {
        NavigationView{
            
            ZStack {
                VStack{
                    Image("Medisync_Logo")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .padding(.top, 80)
                    
                    Spacer().frame(height: 4)
                    
                    Text("Sign Up")
                        .fontDesign(.serif)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        //.padding()
                    
                    TextField("\(Image(systemName: "person.circle"))  Full Name", text:$viewModel.name)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                    
                    TextField("\(Image(systemName: "envelope.fill"))  Email", text:$viewModel.email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                    
                    SecureField("\(Image(systemName: "lock.fill"))  Password", text:$viewModel.password)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                    
                    DatePicker("\(Image(systemName: "birthday.cake"))  Birthday",selection: $viewModel.dateOfBirth, displayedComponents: .date)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                    
                    HStack{
                        Text("Pick Your Role")
                            .font(.title3)
                            .padding()
                        Picker("Select Role", selection: $viewModel.selectedRole) {
                            ForEach(Role.allCases, id: \.self) { role in
                                Text(role.rawValue.capitalized)
                                    .tag(role)
                            }
                        }

                        .foregroundColor(.black)
                        .pickerStyle(.menu)
                        .accentColor(.black)
                        .padding()
                    }
                    
                    Button(action: {
                        viewModel.registerUser() { success in
                            if success {
                                selectedRole = viewModel.selectedRole
                                isRegistered = true
                            }
                        }
                    }) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .bold()
                            .frame(width: 200, height: 55)
                            .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                            .cornerRadius(10)
                    }
                    NavigationLink(
                        destination: destinationView(for: selectedRole),
                        isActive: $isRegistered
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: LoginView()){
                        Text("Already have an Account? Log in")
                            .padding(.top, 10)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 130)
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all) // Ensure gradient fills entire screen
            )
            
        }
    }
    
    @ViewBuilder
    private func destinationView(for role: Role?) -> some View {
        switch role {
        case .doctor:
            DoctorDashboard()
        case .nurse:
            NurseDashboard()
        case .labTech:
            LabTechDashboard()
        case .patient:
            PatientDashboard()
        default:
            WelcomeScreen()
        }
    }
    
}

#Preview {
    RegistrationView()
}
