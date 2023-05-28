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
    @Published var hintsModel = HintsModel()
    
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    
    override init() {
        deviceId = String(UUID().uuidString.split(separator: "-")[0])
        super.init()
        synthesizer.delegate = self
        
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
    
    deinit {
        print("Deinitialised!!!")
    }
}
