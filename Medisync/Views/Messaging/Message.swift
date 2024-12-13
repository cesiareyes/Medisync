//
//  Message.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/10/24.
//

import Foundation

struct Message: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var sender: String //Name of sender
    var receiver: String //Name of receiver
    var content: String
    var subject: String
    var timestamp: Date = Date()
}
