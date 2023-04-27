//
//  ViewModel.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import MultipeerConnectivity
import CoreLocation

class ViewModel: NSObject, ObservableObject {
    @Published var completedChallenges: [GameState] = []
    @Published var gameState = GameState.connection
    @Published var location = Location.academy
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    
    override init() {
        super.init()
        
        setUpMultipeerConnectivity()
    }
    
    func startMonitoring() {
        let manager = CLLocationManager()
        
        switch location {
        case .academy:
            for beacon in CLBeaconRegion.allAcademyBeacons {
                manager.startMonitoring(for: beacon)
            }
        case .foundation:
            for beacon in CLBeaconRegion.allFoundationBeacons {
                manager.startMonitoring(for: beacon)
            }
        }
    }
}
