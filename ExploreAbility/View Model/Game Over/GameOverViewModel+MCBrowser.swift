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
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
}
