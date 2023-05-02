//
//  ViewModel.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import MultipeerConnectivity
import CoreLocation
import AVFAudio
import SwiftUI

class ViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    let manager = CLLocationManager()
    
    var rssis: [Double] = []
    
    @Published var groupName: String = ""
    
    @Published var deviceId: String
    
    @Published var completedChallenges: [GameState] = []
    @Published var gameState = GameState.connection {
        didSet {
            switch gameState {
            case .exploring: say(text: "Put on your blindfolds.")
            case .internalTest, .groupSetUp, .waitingRoom: break
            default: say(text: "Remove your blindfolds.")
            }
        }
    }
    
    @Published var location: Location?
    
    @Published var ipsPosition: IPSPosition?
    
    var hostPeerID: MCPeerID?
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    
    @Published var isConnected = false
    
    override init() {
        deviceId = String(UUID().uuidString.split(separator: "-")[0])
        super.init()
        synthesizer.delegate = self
        
        setUpMultipeerConnectivity()
        startMonitoring()
    }
    
    deinit {
        print("Deinitialised!!!")
    }
    
    func sendHelloMessage() {
        guard let hostPeerID else { return }
        
        let helloMessage = HelloClientMessage(groupName: groupName)
        do {
            let data = try ClientMessage(payload: .hello(helloMessage)).toData()
            
            try mcSession.send(data, toPeers: [hostPeerID], with: .reliable)
            
            withAnimation {
                gameState = .waitingRoom
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendHeartbeatMessage() {
        
        guard let location = manager.location,
              let heading = manager.heading?.trueHeading else { return }
        
//        HeartbeatClientMessage(gameState: gameState,
//                               beaconDistances: <#T##[HeartbeatClientMessage.BeaconProximity]#>,
//                               trueHeading: heading,
//                               gpsLatitude: location.coordinate.latitude,
//                               gpsLongitude: location.coordinate.longitude,
//                               gpsAccuracy: location.horizontalAccuracy,
//                               date: .now)
    }
}
