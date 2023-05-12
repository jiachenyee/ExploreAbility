//
//  NextChallenge.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 12/5/23.
//

import Foundation

struct NextChallenge: Identifiable {
    var id: String {
        groupId + String(challenge.rawValue)
    }
    var groupId: String
    var challenge: GameState
}
