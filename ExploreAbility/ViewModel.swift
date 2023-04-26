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
    @Published var gameState = GameState.closedCaptions
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    
    override init() {
        super.init()
        
        setUpMultipeerConnectivity()
    }
    
    func startMonitoring() {
        let manager = CLLocationManager()
//        manager.startMonitoring(for: <#T##CLRegion#>)
    }
}
