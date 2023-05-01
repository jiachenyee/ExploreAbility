//
//  ViewModel.swift
//  ExploreAbility Beacon Mac
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import AppKit
import MultipeerConnectivity

class ViewModel: NSObject, ObservableObject {
    
    var logger = LoggerViewModel()
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    @Published var isActive = false {
        didSet {
            if isActive {
                startHosting()
            } else {
                stopHosting()
            }
        }
    }
    
    @Published var mapCustomizations = MapCustomisations()
    
    @Published var location: Location = .academy
    
    @Published var roomCaptureData: RoomCaptureData? {
        didSet {
            logger.addLog("Imported Room 3D Model", imageName: "cube.transparent")
        }
    }
    
    @Published var isGameActive = false {
        didSet {
            if isGameActive {
                do {
                    let data = try ConsoleMessage(payload: .startGame(.init(startDate: .now.addingTimeInterval(3)))).toData()
                    
                    guard mcSession != nil else {
                        logger.addLog(.critical, "Unable to start game: No MCSession", imageName: "pc")
                        isGameActive = false
                        return
                    }
                    
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                    logger.addLog(.success, "Sent message to start game", imageName: "flag.checkered.2.crossed")
                    
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        self.logger.addLog(.success, "Game started!", imageName: "flag.checkered.2.crossed")
                    }
                    
                } catch {
                    logger.addLog(.critical, "Unable to start game: \(error.localizedDescription)", imageName: "pc")
                    isGameActive = false
                }
            }
        }
    }
    
    @Published var groups: [Group] = []
    
    @Published var beaconPositions: [Position?] = .init(repeating: nil, count: 5)
    
    override init() {
        super.init()
        
    }
    
    func startHosting() {
        peerID = MCPeerID(displayName: location == .academy ? "Academy" : "Foundation")
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        
        mcSession.delegate = self
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: MCConstant.service,
                                                      discoveryInfo: nil,
                                                      session: mcSession)
        mcAdvertiserAssistant.start()
        
        logger.addLog(.success, "Multipeer Session Started", imageName: "antenna.radiowaves.left.and.right")
    }
    
    func stopHosting() {
        mcSession.disconnect()
        mcAdvertiserAssistant.stop()
        
        logger.addLog(.critical, "Multipeer Session Ended", imageName: "antenna.radiowaves.left.and.right.slash")
    }
}
