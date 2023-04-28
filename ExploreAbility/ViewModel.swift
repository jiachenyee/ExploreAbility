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

class ViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    let manager = CLLocationManager()
    
    var rssis: [Double] = []
    
    @Published var deviceId: String
    
    @Published var completedChallenges: [GameState] = []
    @Published var gameState = GameState.connection {
        didSet {
            print("TEST")
            switch gameState {
            case .exploring: say(text: "Put on your blindfolds.")
            default: say(text: "Remove your blindfolds.")
            }
        }
    }
    @Published var location = Location.academy
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    
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
}
