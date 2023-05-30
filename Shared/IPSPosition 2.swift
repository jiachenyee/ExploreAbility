//
//  IPSPosition.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation

struct IPSPosition: Codable, Equatable {
    var position: Position
    /// Accuracy
    var error: Double
    var date: Date
    
    /// Compass true heading
    var trueHeading: Double?
    
    enum CodingKeys: String, CodingKey {
        case position = "p"
        case error = "e"
        case date = "d"
        case trueHeading = "h"
    }
}
