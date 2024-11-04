import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func login(){
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error: \(error)")
                
            }
        }
    }
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    @State private var showingAlert = false
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
                        .fontDesign(.serif)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 80)
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(height: 60)
                        .keyboardType(.emailAddress)
                        .background(
                            Color.black.opacity(0))
                        .border(Color.black, width: 2)
                        .frame(width: defaultWidth, height: defaultHeight)
                    
                    SecureField("Password", text: $viewModel.password)
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(height: 60)
                        .background(
                            Color.black.opacity(0))
                        .border(Color.black, width: 2)
                        .frame(width: defaultWidth, height: defaultHeight)
                        .padding(.top, 15)
                        .padding(.bottom, 2)
                    
                    // Aligning "Forgot Password?" to the right
                    HStack {
                        Spacer() // Pushes the text to the right
                        NavigationLink(destination: HomeView()) {
                            Text("Forgot Password?")
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .frame(width: defaultWidth) // Set the width to match the input fields
                    .padding(.bottom, 10) // Add a bit of space between the password field and the link
                    
                    
                    Button {
                        viewModel.login()
                    } label: {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: defaultWidth, height: defaultHeight)
                            .background(
                                Color(
                                    red: 0.537,
                                    green: 0.318,
                                    blue: 0.627)
                                .opacity(0.9))
                            .cornerRadius(defaultCornerRadius)
                            .padding(.bottom, 500)
                            .padding(.top, 15)
                    }
                    

                }
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
}

#Preview {
    LoginView()
}
