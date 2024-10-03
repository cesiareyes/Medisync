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
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var dateOfBirth = Date()
    
    @EnvironmentObject var userManager: UserManager
    @State private var registrationSuccess = false
    @State private var showingAlert = false
    @State private var selection = 1
    
    
    var body: some View {
        NavigationView{
            
            ZStack {
                Color.cyan
                    .ignoresSafeArea()
                
                VStack{
                    Text("Sign Up")
                        .fontDesign(.serif)
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                    Text("Create your Account")
                        .foregroundColor(.black.opacity(0.7))
                        .fontDesign(.serif)
                        .padding(.bottom, 50)
                    
                    TextField("\(Image(systemName: "person.circle"))  Full Name", text:$name)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                    
                    TextField("\(Image(systemName: "envelope.fill"))  Email", text:$email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10.0)
                    
                    SecureField("\(Image(systemName: "lock.fill"))  Password", text:$newPassword)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                    
                    DatePicker("\(Image(systemName: "birthday.cake"))  Birthday",selection: $dateOfBirth, displayedComponents: .date)
                        .padding()
                        .frame(width: 360, height: 60)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                    
                    HStack{
                        Text("Pick Your Role")
                            .font(.title3)
                            .padding()
                        Picker(selection: $selection, label: Text("Tell us who you are")){
                            Text("Doctor").tag(1)
                            Text("Nurse").tag(2)
                            Text("Lab Tech").tag(3)
                            Text("Patient").tag(4)
                        }
                        .foregroundColor(.black)
                        .pickerStyle(.menu)
                        .accentColor(.black)
                        .padding()
                    }
                    
            
                    if !newPassword.isEmpty &&
                        !email.isEmpty &&
                        !name.isEmpty{
                            
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
                               name.isEmpty{
                            
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
