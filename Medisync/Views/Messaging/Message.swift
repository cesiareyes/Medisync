//
//  Message.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/10/24.
//

import Foundation

// model for a message
struct Message: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var sender: String
    var receiver: String
    var content: String
    var subject: String
    var timestamp: Date = Date()
}
