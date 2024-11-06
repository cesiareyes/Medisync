import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum Role: String, CaseIterable {
    case doctor
    case nurse
    case labTech
    case patient
}

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var dateOfBirth = Date()
    @Published var role: Role = .patient
    
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
                    "role": role.rawValue // Convert to String
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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("Medisync_Logo")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(.top, 80)
                    
                    Spacer().frame(height: 4)
                    
                    Text("Sign Up")
                        .font(.system(size: 50, weight: .semibold, design: .default)) // San Francisco
                        .foregroundColor(.black)
                    
                    TextField("\(Image(systemName: "person.circle"))  Full Name", text: $viewModel.name)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                        .font(.system(size: 16, design: .default)) // San Francisco
                    
                    TextField("\(Image(systemName: "envelope.fill"))  Email", text: $viewModel.email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                        .font(.system(size: 16, design: .default)) // San Francisco
                    
                    SecureField("\(Image(systemName: "lock.fill"))  Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .font(.system(size: 16, design: .default)) // San Francisco
                    
                    DatePicker("\(Image(systemName: "calendar"))  Birthday", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .font(.system(size: 16, design: .default)) // San Francisco
                    
                    HStack {
                        Text("I am a:")
                            .font(.title3) // San Francisco
                            .padding()
                        
                        Picker("Select Role", selection: $viewModel.role) {
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
                            .font(.system(size: 18, weight: .semibold, design: .default)) // San Francisco
                    }
                    NavigationLink(destination: WelcomeScreen(), isActive: $isRegistered) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an Account? Log in")
                            .padding(.top, 10)
                            .foregroundColor(.white)
                            .font(.system(size: 14, design: .default)) // San Francisco
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
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    RegistrationView()
}
