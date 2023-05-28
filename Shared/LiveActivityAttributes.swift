//
//  LiveActivityAttributes.swift
//  ExploreAbility LiveActivityExtension
//
//  Created by Jia Chen Yee on 4/5/23.
//

import Foundation
import ActivityKit

struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var currentGameState: GameState
        var completedChallenges: [GameState]
        var challengeStart: Date = .now
    }
    
    var startDate: Date = .now
}
