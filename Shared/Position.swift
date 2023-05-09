//
//  Position.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation

struct Position: Codable, Equatable {
    var x: Double
    var y: Double
    
    func distance(to otherPosition: Position) -> Double {
        return sqrt(pow(x - otherPosition.x, 2) + pow(self.y - otherPosition.y, 2))
    }
}
