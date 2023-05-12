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
import ActivityKit

class ViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    let locationManager = CLLocationManager()
    
    var liveActivity: Activity<LiveActivityAttributes>?
    
    @Published var groupName: String = ""
    
    let deviceId: String
    
    @Published var completedChallenges: [GameState] = []
    @Published var gameState = GameState.connection {
        didSet {
            switch gameState {
            case .exploring: say(text: "Put on your blindfolds.")
            case .internalTest, .groupSetUp, .waitingRoom: break
            case .gameOver:
                leaveSession()
                deleteLiveActivity()
                say(text: "Remove your blindfolds.")
            default:
                say(text: "Remove your blindfolds.")
                updateLiveActivity()
                sendChallengeStartedMessage()
            }
        }
    }
    
    @Published var sessionInfo: SessionInfoConsoleMessage?
    
    @Published var ipsPosition: IPSPosition?
    
    var locationData: [LocationDataSource: LocationData] = [:] {
        didSet {
//            let localPosition = calculatePosition(using: locationData, date: .now)
            
//            ipsPosition = localPosition
            
            sendHeartbeatMessage()
        }
    }
    
    var hostPeerID: MCPeerID?
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var browserManager: MCBrowserManager!
    
    var lastHeatbeatMessageDate: Date?
    
    var heartbeatScheduled = false
    
    override init() {
        deviceId = UserDefaults.standard.string(forKey: "deviceID") ?? String(UUID().uuidString.split(separator: "-")[0])
        
        UserDefaults.standard.set(deviceId, forKey: "deviceID")
        
        super.init()
        
        synthesizer.delegate = self
        
        deleteLiveActivity()
        
        setUpMultipeerConnectivity()
        startMonitoring()
        startLiveActivity()
    }
    
    deinit {
        print("Deinitialised!!!")
    }
}
