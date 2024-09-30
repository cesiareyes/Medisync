//
//  ContentView.swift
//  Medisync
//
//  Created by Cesia Reyes on 9/30/24.
//

import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cyan
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                VStack{
                    Text("Medisync Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom, 50)

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                        .frame(width: 350, height: 50)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                        .frame(width: 350, height: 50)
                        .padding(.bottom, 10)
                    
                    Button(action: {
                        if validateLogin(email: email, password: password) {
                            // Handle successful login
                            print("Login successful")
                        } else {
                            // Show an alert for unsuccessful login
                            showingAlert = true
                        }
                    }){
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                            .cornerRadius(10.0)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Invalid Login"), message: Text("Please check your email and password"), dismissButton: .default(Text("OK")))
                    }
                    .padding(.bottom, 10)
                    
                    NavigationLink(destination: RegistrationView()){
                        Text("Not yet Registered? Sign Up")
                    }
                }
            }
        }
    }
    
    
    func validateLogin(email: String, password: String) -> Bool {
    // Simple validation: Check if email and password are not empty
        return !email.isEmpty && !password.isEmpty
    }
}

#Preview {
    ContentView()
}
