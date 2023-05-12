//
//  GameOverViewModel+MCBrowser.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import Foundation
import MultipeerConnectivity

extension GameOverViewModel: MCNearbyServiceBrowserDelegate {
    func setUpBrowser() {
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MCConstant.celebration)
        browser.delegate = self
        
        browser.startBrowsingForPeers()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard peerID.displayName == "Celebration" else { return }
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        
        var retryAttempt = 0
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            if !session.connectedPeers.isEmpty || retryAttempt == 3 {
                timer.invalidate()
            } else {
                browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            }
            
            retryAttempt += 1
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
}
