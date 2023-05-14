//
//  HeartbeatClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct HeartbeatClientMessage: MessageContents {
    var gameState: GameState
    var progress: Double
    
    enum BeaconProximity: Int, Codable {
        case unknown = 0
        case immediate = 1
        case near = 2
        case far = 3
        
        func maxRadius() -> Double? {
            switch self {
            case .unknown: return nil
            case .immediate: return 0.5
            case .near: return 12
            case .far: return 30
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case gameState = "gs"
        case progress = "p"
    }
}
