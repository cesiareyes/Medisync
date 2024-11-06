import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ForgotPassword: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var isRegistered = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Account recovery")
                            .padding(.leading, 24)
                            .font(.system(size: 24, weight: .bold, design: .default)) // Use San Francisco
                            .foregroundColor(.purple)
                            .padding(.bottom, 10)
                        Spacer()
                    }
                    HStack {
                        Text("Enter phone number")
                            .padding(.leading, 10)
                            .font(.system(size: 20, weight: .semibold, design: .default)) // Use San Francisco
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    TextField("\(Image(systemName: "phone"))  Mobile Number", text: $viewModel.name)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                        .font(.system(size: 16, design: .default)) // Use San Francisco
                        .keyboardType(.phonePad) // Ensure only numbers can be input
                        
                    
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
                            .font(.system(size: 18, weight: .semibold, design: .default)) // Use San Francisco
                            .padding(.top, 10)
                    }
                    
                    NavigationLink(destination: HomeView(), isActive: $isRegistered) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Use email instead")
                            .padding(.top, 10)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold, design: .default)) // Use San Francisco
                    }
                }
                .padding(.bottom, 500)
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
    ForgotPassword()
}
