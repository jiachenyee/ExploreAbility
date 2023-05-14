//
//  ViewModel+Messages.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 5/5/23.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

extension ViewModel {
    func sendHelloMessage() {
        guard let hostPeerID else { return }
        
        let helloMessage = HelloClientMessage(groupName: groupName)
        do {
            let data = try ClientMessage(payload: .hello(helloMessage)).toData()
            
            try mcSession.send(data, toPeers: [hostPeerID], with: .reliable)
            
            withAnimation {
                gameState = .waitingRoom
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendHeartbeatMessage() {
        guard abs((lastHeatbeatMessageDate ?? .distantPast).timeIntervalSinceNow) > 1,
              let hostPeerID else {
            if !heartbeatScheduled {
                heartbeatScheduled = true
                
                let newDate = (lastHeatbeatMessageDate ?? .now).advanced(by: 1.001)
                
                Timer.scheduledTimer(withTimeInterval: abs(newDate.timeIntervalSinceNow), repeats: false) { _ in
                    self.sendHeartbeatMessage()
                }
            }
            return
        }
        
        heartbeatScheduled = false
        
        lastHeatbeatMessageDate = .now
        
        let heartbeat = HeartbeatClientMessage(gameState: gameState, progress: progress)
        
        do {
            let data = try ClientMessage(payload: .heartbeat(heartbeat)).toData()
            
            try mcSession.send(data, toPeers: [hostPeerID], with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendChallengeStartedMessage() {
        guard let hostPeerID else { return }
        
        do {
            let data = try ClientMessage(payload: .challengeStarted(ChallengeStartedClientMessage(gameState: gameState, date: .now))).toData()
            
            try mcSession.send(data, toPeers: [hostPeerID], with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}
