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
    
    func leaveSession() {
        mcSession.disconnect()
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        guard peerID.displayName == "Academy" || peerID.displayName == "Foundation" else { return }
        
        hostPeerID = peerID
        
        if state == .connected {
            if sessionInfo == nil {
                Task {
                    await MainActor.run {
                        gameState = .groupSetUp
                    }
                }
            }
            
            browserManager.stop()
        } else if state == .notConnected, let location = sessionInfo?.location {
            browserManager.start(location: location)
            print("Reconnecting")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        didReceiveData(data, from: peerID)
    }
    
    func didReceiveData(_ data: Data, from peerID: MCPeerID) {
        let decoder = JSONDecoder()
        do {
            let consoleMessage = try decoder.decode(ConsoleMessage.self, from: data)
            
            switch consoleMessage.payload {
            case .sessionInfo(let sessionInfo):
                Task {
                    await MainActor.run {
                        self.sessionInfo = sessionInfo
                    }
                }
            case .startGame(let startGame):
                Task {
                    let ttl = abs(startGame.startDate.timeIntervalSinceNow) * 1000

                    try await Task.sleep(for: .milliseconds(Int(ttl)))
                    
                    await MainActor.run {
                        self.gameState = .exploring
                    }
                }
            case .nextChallenge(let nextChallenge):
                #warning("Incomplete implementation")
                print(nextChallenge)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
