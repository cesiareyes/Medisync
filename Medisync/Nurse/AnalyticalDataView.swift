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
        List(viewModel.analyticalData) { data in
            Text(data.description)
        }
        .navigationTitle("Analytical Data")
    }
}
