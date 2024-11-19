//
//  NurseDashboard.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct NurseDashboard: View {
    @StateObject private var viewModel = NurseDashboardViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Nurse Dashboard")
                        .font(.system(size: 35, weight: .semibold, design: .default)) // Use San Francisco
                        .foregroundColor(.black)
                        .padding(.top, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                if selectedTab == 0 {
                    UpdatePatientDataView(viewModel: viewModel)
                } else if selectedTab == 1 {
                    AnalyticalDataView(viewModel: viewModel)
                } else if selectedTab == 2 {
                    MessagesView(viewModel: viewModel)
                }
                
                Spacer()
                
                HStack {
                    TabBarItem(icon: "person", label: "Update Patient", isSelected: selectedTab == 0)
                        .onTapGesture { selectedTab = 0 }
                    Spacer()
                    
                    TabBarItem(icon: "chart.bar", label: "Analytical Data", isSelected: selectedTab == 1)
                        .onTapGesture { selectedTab = 1 }
                    Spacer()
                    
                    TabBarItem(icon: "message", label: "Messages", isSelected: selectedTab == 2)
                        .onTapGesture { selectedTab = 2 }
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    NurseDashboard()
}
