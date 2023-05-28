//
//  Location.swift
//  ExploreAbility Beacon
//
//  Created by Jia Chen Yee on 26/4/23.
//

import Foundation

enum Location: Int, Hashable, Codable, CustomStringConvertible {
    case academy = 1
    case foundation = 2
    
    var description: String {
        switch self {
        case .academy:
            return "Academy"
        case .foundation:
            return "Foundation"
        }
    }
}
