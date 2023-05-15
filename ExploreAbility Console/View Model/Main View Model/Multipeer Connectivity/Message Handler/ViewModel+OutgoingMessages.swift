//
//  ViewModel+OutgoingMessages.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 14/5/23.
//

import Foundation
import MultipeerConnectivity

extension ViewModel {
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

    func sendNextChallengeMessage(nextChallenge: GameState, beacon: Int, to group: inout Group) {
        nextChallengeRequests.removeAll { nextChallenge in
            nextChallenge.groupId == group.id
        }
        
        let message = NextChallengeConsoleMessage(nextChallenge: nextChallenge, beacon: beacon)
        
        do {
            let data = try ConsoleMessage(payload: .nextChallenge(message)).toData()
            try mcSession?.send(data, toPeers: [group.peerID], with: .reliable)
            
            group.nextChallenge = nextChallenge
            group.nextChallengeBeacon = beacon
        } catch {
            logger.addLog(.critical, "Failed to send next challenge message", imageName: "bubble.left.and.exclamationmark.bubble.right")
        }
    }
    
    func sendStartGameMessage() {
        do {
            let data = try ConsoleMessage(payload: .startGame(.init(startDate: .now.addingTimeInterval(3)))).toData()
            
            guard let mcSession else {
                logger.addLog(.critical, "Unable to start game: No MCSession", imageName: "pc")
                isGameActive = false
                return
            }
            
            try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            logger.addLog(.success, "Sent message to start game", imageName: "flag.checkered.2.crossed")
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                self.logger.addLog(.success, "Game started!", imageName: "flag.checkered.2.crossed")
            }
            
        } catch {
            logger.addLog(.critical, "Unable to start game: \(error.localizedDescription)", imageName: "pc")
            isGameActive = false
        }
    }
}
