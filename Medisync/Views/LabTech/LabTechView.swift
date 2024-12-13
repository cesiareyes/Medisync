//
//  LabTechView.swift
//  Medisync
//
//  Created by Karai Arnold on 11/20/24.
//

import SwiftUI

struct LabTechView: View {
    @ObservedObject var viewModel: LabTechDashboardViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(viewModel.LabRequests) { labRequest in
                    LabTechInbox(request: labRequest)
                }
            }
            .padding()
        }
    }
}

struct LabTechInbox: View {
    let request: Inbox

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(request.request)
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Text("\(request.date, style: .date), \(request.time, style: .time)") // Display date and time
                    .foregroundColor(.white.opacity(0.7))
                Text(request.status.rawValue.capitalized)
                    .foregroundColor(statusColor(for: request.status))
                    .font(.footnote).bold()
            }
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }

    private func statusColor(for status: WaitingStatus) -> Color {
        switch status {
        case .pending: return .yellow
        case .ongoing: return .green
        case .completed: return .blue
        case .canceled: return .red
        }
    }
}

#Preview {
    LabTechView(viewModel: LabTechDashboardViewModel())
}
