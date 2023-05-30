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
    
    var logger = Logger.shared
    
    var peerID: MCPeerID!
    var mcSession: MCSession?
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
                sendStartGameMessage()
            }
        }
    }
    
    @Published var groups: [Group] = []
    
    @Published var nextChallengeRequests: [NextChallenge] = []
    
    @Published var beaconPositions: [Position?] = .init(repeating: nil, count: 7) {
        didSet {
            sendSessionInfoMessage()
        }
    }
    
    @Published var originPosition: GPSPosition? {
        didSet {
            sendSessionInfoMessage()
        }
    }
    
    override init() {
        super.init()
        
    }
    
    var nearbyService: MCNearbyServiceAdvertiser!
    
    func startHosting() {
        peerID = MCPeerID(displayName: location == .academy ? "Academy" : "Foundation")
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        
        mcSession!.delegate = self
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: MCConstant.service,
                                                      discoveryInfo: nil,
                                                      session: mcSession!)
        
        nearbyService = MCNearbyServiceAdvertiser(peer: peerID,
                                                  discoveryInfo: nil,
                                                  serviceType: MCConstant.service)
        
        nearbyService.delegate = self
        nearbyService.startAdvertisingPeer()
        
        logger.addLog(.success, "Multipeer Session Started", imageName: "antenna.radiowaves.left.and.right")
    }
    
    func stopHosting() {
        guard let mcSession else { return }
        mcSession.disconnect()
        mcAdvertiserAssistant.stop()
        
        self.mcSession = nil
        logger.addLog(.critical, "Multipeer Session Ended", imageName: "antenna.radiowaves.left.and.right.slash")
    }
}

extension ViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
}
