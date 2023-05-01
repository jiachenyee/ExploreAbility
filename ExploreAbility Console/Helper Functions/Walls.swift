//
//  Walls.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 2/5/23.
//

import Foundation

typealias Walls = [[Position]]

public extension Walls {
    func getLowestAndHighest() -> (lowestX: Double, lowestY: Double, highestX: Double, highestY: Double) {
        var lowestX = Double.infinity
        var lowestY = Double.infinity
        var highestX = -Double.infinity
        var highestY = -Double.infinity
        
        for wall in self {
            for position in wall {
                lowestX = Swift.min(lowestX, position.x)
                lowestY = Swift.min(lowestY, position.y)
                highestX = Swift.max(highestX, position.x)
                highestY = Swift.max(highestY, position.y)
            }
        }
        
        return (lowestX, lowestY, highestX, highestY)
    }
}
