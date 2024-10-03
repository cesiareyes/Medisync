//
//  RegistrationView.swift
//  Medisync
//
//  Created by Cesia Reyes on 10/1/24.
//

import SwiftUI

struct User {
    var firstName: String
    var lastName: String
    var password: String
    var dateOfBirth: Date
    var email: String
}

class UserManager: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?
    
    func registerUser(firstName: String, lastName: String, username: String, password: String, dateOfBirth: Date, email: String) {
            let newUser = User(firstName: firstName, lastName: lastName, password: password, dateOfBirth: dateOfBirth, email: email)
            currentUser = newUser
        }
}

struct RegistrationView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var dateOfBirth = Date()
    
    @EnvironmentObject var userManager: UserManager
    @State private var registrationSuccess = false
    @State private var showingAlert = false
    
    
    var body: some View {
        NavigationView{
            
            ZStack {
                Color.cyan
                    .ignoresSafeArea()
                
                VStack{
                    TextField("First Name", text:$firstName)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                    
                        
                    
                    TextField("Last Name", text:$lastName)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                    
                    TextField("Email", text:$email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                    
                    SecureField("Password", text:$newPassword)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                    
                    DatePicker("Birthday",selection: $dateOfBirth, displayedComponents: .date)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                    
                        .padding(.bottom, 20)
                    
            
                    if !newPassword.isEmpty &&
                        !email.isEmpty &&
                        !lastName.isEmpty &&
                        !firstName.isEmpty{
                            
                        //userManager.registerUser(firstName: firstName, lastName: lastName, password: newPassword, dateOfBirth: dateOfBirth, email: email)
                        NavigationLink(destination: HomeView()){
                            Text("Continue")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 200, height: 60)
                                .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                                .cornerRadius(10)
                            
                        }
                    } else{
                        Button(action: {
                            if newPassword.isEmpty &&
                               email.isEmpty &&
                               lastName.isEmpty &&
                                firstName.isEmpty {
                            
                                showingAlert = true
                            }
                            
                        }){
                            Text("Continue")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 200, height: 60)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Invalid Registration"), message: Text("Please make sure all fields are filled out."), dismissButton: .default(Text("OK")))
                        }
                    }
                    
                    
                
                }
            }
        }
    }
}

#Preview {
    RegistrationView()
}
