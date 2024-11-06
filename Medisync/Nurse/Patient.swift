//
//  Patient.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/6/24.
//

import Foundation

struct Patient: Identifiable, Codable {
    var id: String
    var name: String
    var age: String
}
