//
//  ViewModel+Incoming Messages.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 14/5/23.
//

import Foundation
import MultipeerConnectivity

extension ViewModel {
    func didReceiveData(_ data: Data, from peerID: MCPeerID) {
        let decoder = JSONDecoder()
        do {
            let consoleMessage = try decoder.decode(ConsoleMessage.self, from: data)
            
            switch consoleMessage.payload {
            case .sessionInfo(let sessionInfo):
                received(sessionInfo: sessionInfo)
            case .startGame(let startGame):
                received(startGameCommand: startGame)
            case .nextChallenge(let nextChallenge):
                received(nextChallenge: nextChallenge)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func received(sessionInfo: SessionInfoConsoleMessage) {
        Task {
            await MainActor.run {
                self.sessionInfo = sessionInfo
            }
        }
    }
    
    fileprivate func received(startGameCommand: StartGameConsoleMessage) {
        Task {
            let ttl = abs(startGameCommand.startDate.timeIntervalSinceNow) * 1000
            
            try await Task.sleep(for: .milliseconds(Int(ttl)))
            
            await MainActor.run {
                self.gameState = .exploring
            }
        }
    }
    
    fileprivate func received(nextChallenge: NextChallengeConsoleMessage) {
        self.nextChallenge = nextChallenge
    }
}
