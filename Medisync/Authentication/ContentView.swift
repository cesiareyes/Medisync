//
//  ContentView.swift
//  Medisync
//
//  Created by Cesia Reyes on 9/30/24.
//

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
                VStack{
                    ZStack {
                        Image("SplashScreen")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 1000, height: 700)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .clear, location: 0.0), // Fade in at the top
                                        .init(color: .white, location: 0.2), // Fully visible between 20% and 80% height
                                        .init(color: .white, location: 0.8),
                                        .init(color: .clear, location: 1.0)  // Fade out at the bottom
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("MediSync")
                            .fontDesign(.serif)
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.black) // Ensure the text is white
                            .padding(.bottom, 500)
                    }
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink(destination: RegistrationView()){
                            Text("SIGN UP")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 420, height: defaultHeight)
                                .background(
                                    Color(
                                        red: 0.537,
                                        green: 0.318,
                                        blue: 0.627)
                                    .opacity(0.9))
                        }
                        NavigationLink(destination: LoginView()){
                            Text("LOGIN")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 420, height: defaultHeight)
                                .background(
                                    Color(
                                        red: 0.537,
                                        green: 0.318,
                                        blue: 0.627)
                                    .opacity(0.9))
                        }
                    }.padding(.bottom,50)
                    
                
                    
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Invalid Login"), message: Text("Please check your email and password"), dismissButton: .default(Text("OK")))
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
