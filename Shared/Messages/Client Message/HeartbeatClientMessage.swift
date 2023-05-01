//
//  HeartbeatClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct HeartbeatClientMessage: MessageContents {
    var gameState: GameState
    
    /// Distances to beacons. If a beacon is undetected/unknown, it is marked as `.unknown`. Otherwise, it follows CoreLocation's mapping.
    var beaconDistances: [BeaconProximity]
    
    /// Compass true heading
    var trueHeading: Double
    
    /// GPS latitude value
    var latitude: Double
    
    /// GPS Longitude value
    var gpsLongitude: Double
    
    /// GPS accuracy in meters
    var gpsAccuracy: Double
    
    var date: Date
    
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
}
