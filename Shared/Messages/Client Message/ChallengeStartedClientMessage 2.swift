//
//  ChallengeStartedClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct ChallengeStartedClientMessage: MessageContents {
    var gameState: GameState
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case gameState = "gs"
        case date = "d"
    }
}
