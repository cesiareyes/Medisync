//
//  Models.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import Foundation

struct Patient: Identifiable {
    var id: String = UUID().uuidString 
    var name: String
    var age: Int
    var bloodType: String
    var height: Int?
    var weight: Int?
    var symptoms: [SymptomDetail]
    var medications: String
    var immunizations: String
    var dateOfBirth: Date = Date()
}

struct AnalyticalData: Identifiable {
    var id: UUID
    var description: String
}
