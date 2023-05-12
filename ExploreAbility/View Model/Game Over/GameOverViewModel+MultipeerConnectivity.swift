//
//  GameOverViewModel+MultipeerConnectivity.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import Foundation
import MultipeerConnectivity

extension GameOverViewModel: MCSessionDelegate {
    
    func setUpMultipeerConnectivity() {
        peerID = MCPeerID(displayName: UserDefaults.standard.string(forKey: "deviceID")!)
        session = MCSession(peer: peerID,
                            securityIdentity: nil,
                            encryptionPreference: .none)
        session.delegate = self
        
        setUpBrowser()
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
