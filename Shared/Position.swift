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
    
    func toAngle(from otherPosition: Position) -> Double {
        let deltaX = x - otherPosition.x
        let deltaY = y - otherPosition.y
        
        let angle = atan2(deltaY, deltaX)
        
        return angle
    }
    
    func toAngle(from otherPosition: Position, withHeading heading: Double) -> Double {
        let angle = toAngle(from: otherPosition)
        
        let angleWithHeading = angle - heading
        
        return angleWithHeading
    }
    
    func getMidpointPosition(with finalPosition: Position, progress: Double) -> Position {
        let deltaX = finalPosition.x - x
        let deltaY = finalPosition.y - y
        
        let intermediateX = x + progress * deltaX
        let intermediateY = y + progress * deltaY
        
        return Position(x: intermediateX, y: intermediateY)
    }
}
