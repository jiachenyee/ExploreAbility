//
//  MCBrowserManager.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 4/5/23.
//

import Foundation
import MultipeerConnectivity

class MCBrowserManager: NSObject, MCNearbyServiceBrowserDelegate {
    
    private let peerID: MCPeerID
    private let browser: MCNearbyServiceBrowser
    private var location: Location?
    
    
    private var session: MCSession
    
    init(session: MCSession) {
        peerID = session.myPeerID
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MCConstant.service)
        self.session = session
        
        super.init()
        
        browser.delegate = self
    }
    
    func start(location: Location) {
        browser.startBrowsingForPeers()
        self.location = location
    }
    
    func stop() {
        browser.startBrowsingForPeers()
    }
    
    var isInviting = false
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard peerID.displayName == location?.description else { return }
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
        
        isInviting = true
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost", peerID.displayName)
    }
}
