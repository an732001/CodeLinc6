//
//  Benefit.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/28/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

struct Benefit {
    var name: String
    var maxGroup: Int
    var minAge: Int
    var genders: [Gender]
    
    enum Gender: CaseIterable {
        case male
        case female
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "Benefit"
        case maxGroup = "MaxGroup"
        case minAge = "MinAge"
        case genders = "Gender"
    }
}

// MARK: - Codable
extension Benefit: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        maxGroup = try values.decode(Int.self, forKey: .maxGroup)
        minAge = try values.decode(Int.self, forKey: .minAge)
        let genderAsInt = try values.decode(Int.self, forKey: .genders)
        switch genderAsInt {
        case 0:
            genders = [.male]
        case 1:
            genders = [.female]
        default:
            genders = Gender.allCases
        }
    }
}
