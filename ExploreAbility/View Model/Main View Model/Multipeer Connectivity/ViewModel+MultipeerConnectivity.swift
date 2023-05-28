//
//  ViewModel+MultipeerConnectivity.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import MultipeerConnectivity

extension ViewModel: MCSessionDelegate {
    func setUpMultipeerConnectivity() {
        peerID = MCPeerID(displayName: deviceId)
        mcSession = MCSession(peer: peerID,
                              securityIdentity: nil,
                              encryptionPreference: .none)
        mcSession.delegate = self
        
        browserManager = MCBrowserManager(session: mcSession)
    }
    
    func startSearching(for location: Location) {
        browserManager.start(location: location)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        guard peerID.displayName == "Academy" || peerID.displayName == "Foundation" else { return }
        
        hostPeerID = peerID
        
        if state == .connected {
            Task {
                await MainActor.run {
                    if sessionInfo == nil {
                        gameState = .groupSetUp
                    }
                    
                    isConnected = true
                }
            }
            
            browserManager.stop()
        } else if state == .notConnected, let location = sessionInfo?.location {
            browserManager.start(location: location)
            print("Reconnecting")
            
            Task {
                await MainActor.run {
                    isConnected = false
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        didReceiveData(data, from: peerID)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
