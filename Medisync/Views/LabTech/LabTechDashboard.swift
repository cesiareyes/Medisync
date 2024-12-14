//
//  LabTechDashboard.swift
//  Medisync
//
//  Created by karai Arnold on 11/18/24.
//

import SwiftUI

struct LabTechDashboard: View {
    
    @StateObject private var viewModel = LabTechDashboardViewModel()
    @StateObject private var messagesViewModel = MessagesViewModel()
    @State private var selectedTab: Int = 0
    @State private var userName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(gradient: Gradient(colors:[.white, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    if selectedTab == 0{
                        Text("Welcome, \(userName)")
                            .font(.system(size: 28, weight: .semibold, design: .default))
                            .foregroundColor(.black)
                            .padding(.top, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        LabWelcomeView()
                        LabTechView(viewModel: viewModel)
                        
                    } else if selectedTab == 1 {
                        Text("Inbox")
                            .font(.system(size: 35, weight: .semibold, design: .default))
                            .foregroundColor(.black)
                            .padding(.top, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        MessagesView(
                            messagesViewModel: messagesViewModel,
                            availableUsers: messagesViewModel.availableUsers
                        )
                    }
                    else if selectedTab == 2 {
                        Profile()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        LabTabBarItem(icon: "chart.bar", label: "Labs", isSelected: selectedTab == 0)
                            .onTapGesture { selectedTab = 0 }
                        Spacer()
                        
                        LabTabBarItem(icon: "message", label: "Messages", isSelected: selectedTab == 1)
                            .onTapGesture { selectedTab = 1 }
                        Spacer()
                        LabTabBarItem(icon: "person.crop.circle", label: "Settings", isSelected:
                                        selectedTab == 2)
                        .onTapGesture { selectedTab = 2}
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                AuthenticationManager.shared.fetchUserName { name in
                    if let name = name {
                        self.userName = name
                    } else {
                        print("Could not retrieve user name.")
                    }
                }
            }
        }
    }
}

struct LabWelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                    
            Text("LabTech Dashboard")
                .font(.system(size: 35, weight: .semibold, design: .default))
                .foregroundColor(.black)
                .padding(.top, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
}

struct LabTabBarItem: View {
    let icon: String
    let label: String
    var isSelected: Bool

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isSelected ? .white : .gray)
            Text(label)
                .font(.footnote)
                .foregroundColor(isSelected ? .white : .gray)
        }
    }
}



#Preview {
    LabTechDashboard()
}
