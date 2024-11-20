//
//  LabTechDashboard.swift
//  Medisync
//
//  Created by karai Arnold on 11/18/24.
//

import SwiftUI

struct LabTechDashboard: View {
    
    @StateObject private var viewModel = LabTechDashboardViewModel()
    @StateObject private var pendingInbox = PendingInbox()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors:[.white, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8){
                    Text("LabTech Dashboard").font(.system(size: 35, weight: .semibold, design: .default)).foregroundColor(.black) .padding(.top, 15) .frame(maxWidth: .infinity, alignment: .leading).padding()
                }
                
                if selectedTab == 0{
                    LabTechView(viewModel: viewModel)
                    
                    }
                else if selectedTab == 1 {
                    if let firstRequest = viewModel.LabRequests.first {
                        LabInbox(labRequest: firstRequest)
                    }
                }
                
                HStack {
                    Spacer()
                    LabTabBarItem(icon: "chart.bar", label: "Labs", isSelected: selectedTab == 0)
                        .onTapGesture { selectedTab = 0 }
                    Spacer()
                    
                    LabTabBarItem(icon: "message", label: "Messages", isSelected: selectedTab == 1)
                        .onTapGesture { selectedTab = 1 }
                    Spacer()
                }
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
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
