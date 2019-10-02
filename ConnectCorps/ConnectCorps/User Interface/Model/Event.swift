//
//  Event.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/28/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation
import CoreLocation

/// Represents an event for job search.
struct Event {
    /// The id of the event.
    var id: Int
    /// The name of the event.
    var name: String
    /// The location of the event.
    var location: CLLocation
    /// The time of the event.
    var time: Date
    /// The cost to attend the event.
    var cost: Decimal
}

// MARK: - Equatable
extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Identifiable
extension Event: Identifiable { }
