//
//  Group.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 30/4/23.
//

import Foundation
import MultipeerConnectivity

struct Group: Identifiable, Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        name
    }
    
    var name: String
    var peerID: MCPeerID
    var completedChallenges: [GameState] = []
    
    var currentState: GameState?
    var position: IPSPosition?
    
    var nextChallenge: GameState?
    var nextChallengePosition: Position?
    
    var isOnline = true
    
    var lastUpdated: Date?
}
