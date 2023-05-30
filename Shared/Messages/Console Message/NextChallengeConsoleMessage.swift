//
//  NextChallengeConsoleMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct NextChallengeConsoleMessage: MessageContents {
    var challenge: GameState
    var beacon: Int
    
    enum CodingKeys: String, CodingKey {
        case challenge = "nc"
        case beacon = "p"
    }
}
