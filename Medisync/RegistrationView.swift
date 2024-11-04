//
//  RegistrationView.swift
//  Medisync
//
//  Created by Cesia Reyes on 10/1/24.
//

import SwiftUI
import FirebaseAuth

struct User {
    var firstName: String
    var lastName: String
    var password: String
    var dateOfBirth: Date
    var email: String
}

class UserManager: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: FirebaseAuth.User?
    
    func registerUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else if let firebaseUser = authResult?.user {
                self.currentUser = firebaseUser
                completion(nil)
            }
        }
    }
        
    func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else if let firebaseUser = authResult?.user {
                self.currentUser = firebaseUser
                completion(nil)
            }
        }
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
    @State private var defaultWidth: CGFloat = 380
    @State private var defaultHeight: CGFloat = 60
    @State private var defaultOpacity: CGFloat = 0.5
    @State private var defaultCornerRadius: CGFloat = 10.0
    
    
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
                                .frame(width: 200, height: 55)
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
                                .frame(width: 200, height: 55)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Invalid Registration"), message: Text("Please make sure all fields are filled out."), dismissButton: .default(Text("OK")))
                        }
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
    
}



#Preview {
    RegistrationView()
}
