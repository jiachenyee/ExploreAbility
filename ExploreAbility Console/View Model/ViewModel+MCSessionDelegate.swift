//
//  ViewModel+MCSessionDelegate.swift.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import MultipeerConnectivity

extension ViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting:
            logger.addLog("Connecting to \(peerID.displayName)…", imageName: "antenna.radiowaves.left.and.right")
        case .connected:
            logger.addLog("Connected to \(peerID.displayName)", imageName: "antenna.radiowaves.left.and.right")
        case .notConnected:
            guard let peerIndex = groups.firstIndex(where: {
                $0.peerID == peerID
            }) else { return }
            
            Task {
                await MainActor.run {
                    groups[peerIndex].isOnline = false
                }
            }
            logger.addLog("Disconnected from \(peerID.displayName)", imageName: "antenna.radiowaves.left.and.right.slash")
        @unknown default: fatalError()
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
