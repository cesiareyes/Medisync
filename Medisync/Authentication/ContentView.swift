import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var defaultHeight: CGFloat = 50
    @State private var defaultWidth: CGFloat = 350
    @State private var defaultPadding: CGFloat = 10
    @State private var defaultOpacity: CGFloat = 0.5
    @State private var passWordWrong: Bool = true

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack {
                        Image("SplashScreen")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 1000, height: 700)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .clear, location: 0.0),
                                        .init(color: .white, location: 0.2),
                                        .init(color: .white, location: 0.8),
                                        .init(color: .clear, location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("MediSync")
                            .font(.system(size: 50, weight: .bold, design: .default)) // San Francisco
                            .foregroundColor(.black)
                            .padding(.bottom, 500)
                    }
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink(destination: RegistrationView()) {
                            Text("SIGN UP")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 200, height: 55)
                                .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                                .cornerRadius(10)
                                .font(.system(size: 18, weight: .semibold, design: .default)) // Use San Francisco
                        }
                        NavigationLink(destination: LoginView()) {
                            Text("LOGIN")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 200, height: 55)
                                .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                                .cornerRadius(10)
                                .font(.system(size: 18, weight: .semibold, design: .default)) // Use San Francisco
                        }
                    }
                    .padding(.bottom, 50)
                    
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Invalid Login")
                                .font(.system(size: 18, weight: .bold, design: .default)), // San Francisco
                            message: Text("Please check your email and password")
                                .font(.system(size: 16, design: .default)), // San Francisco
                            dismissButton: .default(
                                Text("OK")
                                    .font(.system(size: 16, weight: .bold, design: .default)) // San Francisco
                            )
                        )
                    }
                }
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
    ContentView()
}
