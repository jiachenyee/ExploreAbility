//
//  ChallengeFinishedClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 5/5/23.
//

import Foundation

struct ChallengeFinishedClientMessage: MessageContents {
    var gameState: GameState
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case gameState = "gs"
        case date = "d"
    }
}
