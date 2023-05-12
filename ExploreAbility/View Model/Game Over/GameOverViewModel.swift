//
//  GameOverViewModel.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import Foundation
import CoreMotion
import MultipeerConnectivity

class GameOverViewModel: NSObject, ObservableObject {
    
    @Published var state = GameOverState.ar
    
    let motionManager = CMMotionManager()
    
    var collectedMotionData: [Double] = []
    
    var peerID: MCPeerID!
    var session: MCSession!
    
    var browser: MCNearbyServiceBrowser!
    
    override init() {
        super.init()
        startMotionUpdates()
        setUpMultipeerConnectivity()
    }
    
    deinit {
        stopMotionUpdates()
    }
}
