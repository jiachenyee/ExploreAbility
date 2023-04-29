//
//  ViewModel.swift
//  ExploreAbility Beacon Mac
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import AppKit
import MultipeerConnectivity

struct Group: Identifiable {
    var id: String {
        name
    }
    
    var name: String {
        peerID.displayName
    }
    var peerID: MCPeerID
    var completedChallenges: [GameState] = []
    
    var currentState: GameState?
    var nextChallenge: GameState?
    
    var position: IPSPosition?
}

class ViewModel: NSObject, ObservableObject, MCSessionDelegate {
    
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
    @Published var location: Location = .academy
    
    @Published var roomCaptureData: RoomCaptureData? {
        didSet {
            logger.addLog("Imported Room 3D Model", imageName: "cube.transparent")
        }
    }
    
    @Published var groups: [Group] = []
    
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
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            Task {
                await MainActor.run {
                    groups.append(Group(peerID: peerID))
                }
            }
            logger.addLog("Connected to \(peerID.displayName)", imageName: "antenna.radiowaves.left.and.right")
        } else if state == .notConnected {
            guard let peerIndex = groups.firstIndex(where: {
                $0.peerID == peerID
            }) else { return }
            
            groups.remove(at: peerIndex)
            
            logger.addLog("Disconnected from \(peerID.displayName)", imageName: "antenna.radiowaves.left.and.right.slash")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        logger.addLog("Received data from \(peerID.displayName): \(data.count) bytes", imageName: "bubble.right.fill")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

}
