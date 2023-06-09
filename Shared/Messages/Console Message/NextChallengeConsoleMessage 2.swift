//
//  NextChallengeConsoleMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct NextChallengeConsoleMessage: MessageContents {
    var nextChallenge: GameState
    var beacon: Int
    
    enum CodingKeys: String, CodingKey {
        case nextChallenge = "nc"
        case beacon = "p"
    }
}
