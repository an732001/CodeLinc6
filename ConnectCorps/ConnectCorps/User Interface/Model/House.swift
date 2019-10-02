//
//  House.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/28/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI
import CoreLocation

/// Represents a house for a veteran.
struct House {
    /// The id of the house.
    var id: Int
    /// The name of the house.
    var name: String
    /// The contact for the house.
    var phoneNumber: String
    /// The address for the house.
    var address: String
    /// The location for the house.
    var location: CLLocation?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "number"
        case address
        case location
    }
}

// MARK: - Equatable

extension House: Equatable {
    static func == (lhs: House, rhs: House) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Identifiable
extension House: Identifiable { }

// MARK: - Codable
extension House: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        address = try values.decode(String.self, forKey: .address)
    }
}
