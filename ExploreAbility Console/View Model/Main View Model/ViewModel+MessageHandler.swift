//
//  ViewModel+MessageHandler.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import MultipeerConnectivity

extension ViewModel {
    func didReceiveData(_ data: Data, from peerID: MCPeerID) {
        let decoder = JSONDecoder()
        do {
            let clientMessage = try decoder.decode(ClientMessage.self, from: data)
            
            switch clientMessage.payload {
            case .hello(let helloMessage):
                receivedHelloMessage(helloMessage, from: peerID)
                
                logger.addLog("Received Hello Message from \(peerID.displayName)", imageName: "hand.wave")
                
            case .heartbeat(let heartbeatMessage):
                receivedHeartbeatMessage(heartbeatMessage, from: peerID)
                
            case .challengeStarted(_):
                break
            }
            
        } catch {
            logger.addLog("Unable to decode data from \(peerID.displayName): \(data.count) bytes", imageName: "questionmark.circle")
        }
    }
    
    fileprivate func receivedHelloMessage(_ helloMessage: HelloClientMessage, from peerID: MCPeerID) {
        Task {
            await MainActor.run {
                groups.append(Group(name: helloMessage.groupName, peerID: peerID))
            }
        }
        
        sendSessionInfoMessage(to: [peerID])
    }
    
    func sendSessionInfoMessage(to peerIDs: [MCPeerID]? = nil) {
        guard let mcSession, !mcSession.connectedPeers.isEmpty else { return }
        do {
            let sessionInfo = SessionInfoConsoleMessage(hostID: mcSession.myPeerID.displayName,
                                                        location: location,
                                                        beaconLocations: beaconPositions,
                                                        originPosition: originPosition)
            
            let data = try ConsoleMessage(payload: .sessionInfo(sessionInfo)).toData()
            
            try mcSession.send(data, toPeers: peerIDs ?? mcSession.connectedPeers, with: .reliable)
        } catch {
            logger.addLog(.critical, "Error responding to Hello: \(error.localizedDescription)", imageName: "waveform.badge.exclamationmark")
        }
    }
    
    fileprivate func receivedHeartbeatMessage(_ heartbeatMessage: HeartbeatClientMessage, from peerID: MCPeerID) {
        guard let groupIndex = groups.firstIndex(where: {
            $0.peerID == peerID
        }) else { return }
        
        // Update group info
        Task {
            await MainActor.run {
                groups[groupIndex].currentState = heartbeatMessage.gameState
                groups[groupIndex].position = heartbeatMessage.ipsPosition
                groups[groupIndex].lastUpdated = .now
            }
        }
    }
}
