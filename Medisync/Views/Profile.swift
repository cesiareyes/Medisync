//
//  Profile.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/11/24.
//

import SwiftUI

struct SettingRowView : View {
    var title : String
    var systemImageName : String
    
    var body : some View {
        HStack (spacing : 15) {
            Image(systemName: systemImageName)
            Text (title)
        }
    }
}

struct Profile: View {
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Settings")
                    .font(.system(size: 35, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                List {
                    Section(header: Text("Account")) {
                        NavigationLink(destination: AccountView()) {
                            SettingRowView(title: "Account",
                                           systemImageName: "person.crop.circle")
                            .font(.title2)
                            .padding(.vertical, 6)
                            .foregroundColor(Color.black.opacity(0.9))
                            
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.purple.opacity(0.25), Color.blue.opacity(0.25)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                        )

                    }
                    
                    Section(header: Text("Logout")) {
                        NavigationLink(destination: LoginView()) {
                            SettingRowView(title: "Logout",
                                           systemImageName: "rectangle.portrait.and.arrow.right")
                            .font(.title2)
                            .padding(.vertical, 6)
                            .foregroundColor(Color.black.opacity(0.9))
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.purple.opacity(0.25), Color.blue.opacity(0.25)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                        )

                    }
                }
                .listStyle(GroupedListStyle())
                .background(Color.clear)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AccountView: View {
    @State private var userName: String = ""
    @State private var email: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Account Information")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Name:")
                            .font(.title2)
                            .foregroundColor(.black)
                        Spacer()
                        Text(userName)
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.8))
                            .multilineTextAlignment(.trailing)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.25), Color.blue.opacity(0.25)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                        ))
                    )
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .frame(width: 360, height: 60)
                    
                    HStack {
                        Text("Email:")
                            .font(.title2)
                            .foregroundColor(.black)
                        Spacer()
                        Text(email)
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.8))
                            .multilineTextAlignment(.trailing)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.25), Color.blue.opacity(0.25)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                            ))
                    )
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .frame(width: 360, height: 60)
                    
                    HStack {
                        Text("Password:")
                            .font(.title2)
                            .foregroundColor(.black)
                        Spacer()
                        Text("*******")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.8))
                            .multilineTextAlignment(.trailing)
                        
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.25), Color.blue.opacity(0.25)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                            ))
                    )
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                    .frame(width: 360, height: 60)
                }
                .padding()
                
                Spacer()
            }
            .onAppear {
                AuthenticationManager.shared.fetchUserName { name in
                    if let name = name {
                        self.userName = name
                    } else {
                        print("Could not retrieve user name")
                    }
                }
                AuthenticationManager.shared.fetchEmail { email in
                    if let email = email {
                        self.email = email
                    } else {
                        print("Could not retrieve email")
                    }
                }
            }
        }
    }
}

#Preview {
    Profile()
}
