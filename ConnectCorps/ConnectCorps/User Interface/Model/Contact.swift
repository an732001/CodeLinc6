//
//  Contact.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/28/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI
import Foundation

/// Represents a contact that a veteran can use to get help.
struct Contact {
    /// The name of the contact.
    var name: String
    /// The description of the contact.
    var description: String
    /// The phone number of the contact.
    var phoneNumber: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Service"
        case description = "Description"
        case phoneNumber = "PhoneNumber"
    }
}

// MARK: - Codable
extension Contact: Codable { }
