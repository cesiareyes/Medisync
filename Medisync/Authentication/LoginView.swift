import SwiftUI
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func login(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        Task {
            do {
                let user = try await Auth.auth().signIn(withEmail: email, password: password)
                print("Success")
                print(user)
                completion(true)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isLoggedIn = false
    @State private var defaultHeight: CGFloat = 50
    @State private var defaultWidth: CGFloat = 400
    @State private var defaultCornerRadius: CGFloat = 4
    @State private var defaultPadding: CGFloat = 10
    @State private var defaultOpacity: CGFloat = 0.5
    @State private var passWordWrong: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Login")
                        .font(.system(size: 50, weight: .semibold, design: .default)) // Use San Francisco
                        .foregroundColor(.black)
                    
                    TextField("\(Image(systemName: "envelope.fill"))  Email", text: $viewModel.email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                        .font(.system(size: 16, design: .default)) // Use San Francisco
                    
                    SecureField("\(Image(systemName: "lock.fill"))  Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .font(.system(size: 16, design: .default)) // Use San Francisco
    
                    HStack {
                        Spacer()
                        NavigationLink(destination: WelcomeScreen()) {
                            NavigationLink(destination: ForgotPassword()) {
                                Text("Forgot Password?")
                                    .padding(.top, 3)
                                    .foregroundColor(.blue)
                                    .padding(.trailing, 25)
                                    .font(.system(size: 16, weight: .semibold, design: .default)) // Use San Francisco
                            }
                        }
                    }
                    .frame(width: defaultWidth)
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        viewModel.login() { success in
                            if success {
                                isLoggedIn = true
                            }
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .bold()
                            .frame(width: 200, height: 55)
                            .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .semibold, design: .default)) // Use San Francisco
                    }
                    NavigationLink(destination: ForgotPassword()) {
                        Text("Not a user? Signup")
                            .padding(.top, 10)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18, weight: .semibold, design: .default)) // Use San Francisco
                    }
                    
                    NavigationLink(destination: WelcomeScreen(), isActive: $isLoggedIn) {
                        EmptyView()
                    }
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
    
}

#Preview {
    LoginView()
}
