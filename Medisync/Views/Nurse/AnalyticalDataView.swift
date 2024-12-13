//
//  AnalyticalDataView.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct AnalyticalDataView: View {
    @ObservedObject var viewModel: NurseDashboardViewModel

    var body: some View {
        VStack {
            if viewModel.analyticalData.isEmpty {
                Text("No analytical data available.")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.analyticalData) { data in
                    Text(data.description)
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: .infinity)
            }
        }
        .onAppear {
            viewModel.fetchAnalyticalData() 
        }
    }
}




