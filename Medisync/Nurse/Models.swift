//
//  Models.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import Foundation

struct Patient: Identifiable {
    var id: UUID
    var name: String
    var age: Int
    var bloodType: String
    var height: Double
    var weight: Double
    // Add more patient details here
}

struct Message: Identifiable {
    var id: UUID
    var sender: String
    var subject: String
    var content: String
    // Add more message details here
}

struct AnalyticalData: Identifiable {
    var id: UUID
    var description: String
    // Add more analytical data details here
}
