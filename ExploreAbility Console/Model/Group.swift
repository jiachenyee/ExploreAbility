//
//  Group.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 30/4/23.
//

import Foundation
import MultipeerConnectivity

struct Group: Identifiable {
    var id: String {
        name
    }
    
    var name: String {
        peerID.displayName
    }
    var peerID: MCPeerID
    var completedChallenges: [GameState] = []
    
    var currentState: GameState?
    var position: IPSPosition?
    
    var nextChallenge: GameState?
    var nextChallengePosition: Position?
    
    var compassHeading: Double? // in degrees
}
