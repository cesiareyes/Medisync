//
//  NurseDashboardViewModel.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

class NurseDashboardViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var messages: [Message] = []
    @Published var analyticalData: [AnalyticalData] = []
}
