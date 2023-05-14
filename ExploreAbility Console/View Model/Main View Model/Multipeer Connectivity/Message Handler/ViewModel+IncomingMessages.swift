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
                
            case .heartbeat(let heartbeatMessage):
                receivedHeartbeatMessage(heartbeatMessage, from: peerID)
                
            case .challengeStarted(let challengeStartedMessage):
                receivedChallengeStartMessage(challengeStartedMessage, from: peerID)
                
            case .challengeFinished(let challengeFinishedMessage):
                receivedChallengeFinishedMessage(challengeFinishedMessage)
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
        
        logger.addLog("Received Hello Message from \(peerID.displayName)", imageName: "hand.wave")
    }
    
    fileprivate func receivedHeartbeatMessage(_ heartbeatMessage: HeartbeatClientMessage, from peerID: MCPeerID) {
        guard let groupIndex = groups.firstIndex(where: {
            $0.peerID == peerID
        }) else { return }
        
        // Update group info
        Task {
            await MainActor.run {
                groups[groupIndex].currentState = heartbeatMessage.gameState
                groups[groupIndex].progress = heartbeatMessage.progress
                groups[groupIndex].lastUpdated = .now
            }
        }
    }
    
    fileprivate func receivedChallengeStartMessage(_ challengeStartedMessage: ChallengeStartedClientMessage, from peerID: MCPeerID) {
        guard let groupIndex = groups.firstIndex(where: { $0.peerID.displayName == peerID.displayName }) else { return }
        
        groups[groupIndex].currentState = challengeStartedMessage.gameState
        
        if let nextChallenge = challengeStartedMessage.gameState.next {
            nextChallengeRequests.append(NextChallenge(groupId: groups[groupIndex].id,
                                                       challenge: nextChallenge))
        }
        
        logger.addLog("\(groups[groupIndex].name) started \(challengeStartedMessage.gameState.description)", imageName: "flag.checkered")
    }
    
    fileprivate func receivedChallengeFinishedMessage(_ challengeFinishedMessage: ChallengeFinishedClientMessage) {
        guard let groupIndex = groups.firstIndex(where: { $0.peerID == peerID }) else { return }
        
        groups[groupIndex].completedChallenges.append(challengeFinishedMessage.gameState)
        groups[groupIndex].currentState = .exploring
        groups[groupIndex].lastUpdated = .now
        
        logger.addLog("\(groups[groupIndex].name) finished \(challengeFinishedMessage.gameState.description)", imageName: "medal")
    }
}
