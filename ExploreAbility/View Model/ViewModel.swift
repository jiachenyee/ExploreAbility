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
            default:
                say(text: "Remove your blindfolds.")
                updateLiveActivity()
            }
        }
    }
    
    @Published var sessionInfo: SessionInfoConsoleMessage?
    
    @Published var ipsPosition: IPSPosition?
    
    var locationData: [LocationDataSource: LocationData] = [:] {
        didSet {
            let localPosition = calculatePosition(using: Array(locationData.values), date: .now)
            
            ipsPosition = localPosition
            
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
        
        setUpMultipeerConnectivity()
        startMonitoring()
        startActivity()
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
        guard abs((lastHeatbeatMessageDate ?? .distantPast).timeIntervalSinceNow) > 1,
              let hostPeerID,
              let ipsPosition else {
            heartbeatScheduled = true
            
            let newDate = lastHeatbeatMessageDate!.advanced(by: 1.001)
            
            Timer.scheduledTimer(withTimeInterval: abs(newDate.timeIntervalSinceNow), repeats: false) { _ in
                self.sendHeartbeatMessage()
            }
            
            return
        }
        
        heartbeatScheduled = false
        
        lastHeatbeatMessageDate = .now
        
        let heartbeat = HeartbeatClientMessage(gameState: gameState, ipsPosition: ipsPosition)
        
        do {
            let data = try ClientMessage(payload: .heartbeat(heartbeat)).toData()
            
            try mcSession.send(data, toPeers: [hostPeerID], with: .reliable)
            
            withAnimation {
                gameState = .waitingRoom
            }
        } catch {
            print(error.localizedDescription)
        }
        print(heartbeat)
    }
    
    func calculatePosition(using locationData: [LocationData], date: Date) -> IPSPosition? {
        let filteredLocationData = locationData.filter { abs($0.date.timeIntervalSinceNow) < 5 }
        
        // Check if we have at least 3 beacons
        if filteredLocationData.count < 3 {
            print("At least 3 beacons are required for trilateration")
            return nil
        }
        
        // Find the weighted centroid
        var sumWeightedX = 0.0
        var sumWeightedY = 0.0
        var sumWeights = 0.0
        
        for beacon in filteredLocationData {
            let weight = 1.0 / (beacon.distance * beacon.distance)
            sumWeightedX += beacon.position.x * weight
            sumWeightedY += beacon.position.y * weight
            sumWeights += weight
        }
        
        let centroidX = sumWeightedX / sumWeights
        let centroidY = sumWeightedY / sumWeights
        let centroid = Position(x: centroidX, y: centroidY)
        
        // Create that circle thing that mapping apps do around points
        var errorEstimate = 0.0
        
        for beacon in locationData {
            let deltaX = beacon.position.x - centroidX
            let deltaY = beacon.position.y - centroidY
            let distanceError = sqrt(deltaX * deltaX + deltaY * deltaY) - beacon.distance
            errorEstimate += distanceError * distanceError
        }
        errorEstimate = sqrt(errorEstimate / Double(locationData.count))
        
        return IPSPosition(position: centroid, error: errorEstimate, date: date, trueHeading: locationManager.heading?.trueHeading)
    }
}
