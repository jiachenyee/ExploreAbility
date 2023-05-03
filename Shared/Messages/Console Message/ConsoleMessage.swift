//
//  ConsoleMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct ConsoleMessage: Codable {
    private(set) var messageCode: MessageCode
    
    var payload: DecodedMessageContents
    
    init(payload: DecodedMessageContents) {
        self.payload = payload
        switch payload {
        case .sessionInfo(_):
            messageCode = .sessionInfo
        case .startGame(_):
            messageCode = .startGame
        case .nextChallenge(_):
            messageCode = .nextChallenge
        }
    }
    
    enum MessageCode: Int, Codable {
        case sessionInfo = 2
        case startGame = 5
        case nextChallenge = 7
    }
    
    enum DecodedMessageContents {
        case sessionInfo(SessionInfoConsoleMessage)
        case startGame(StartGameConsoleMessage)
        case nextChallenge(NextChallengeConsoleMessage)
    }
    
    enum CodingKeys: String, CodingKey {
        case messageCode = "c"
        case payload = "p"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageCode, forKey: .messageCode)
        
        switch payload {
        case .sessionInfo(let payloadData):
            try container.encode(payloadData, forKey: .payload)
        case .startGame(let payloadData):
            try container.encode(payloadData, forKey: .payload)
        case .nextChallenge(let payloadData):
            try container.encode(payloadData, forKey: .payload)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.messageCode = try container.decode(MessageCode.self, forKey: .messageCode)
        
        switch messageCode {
        case .sessionInfo:
            self.payload = .sessionInfo(try container.decode(SessionInfoConsoleMessage.self, forKey: .payload))
        case .startGame:
            self.payload = .startGame(try container.decode(StartGameConsoleMessage.self, forKey: .payload))
        case .nextChallenge:
            self.payload = .nextChallenge(try container.decode(NextChallengeConsoleMessage.self, forKey: .payload))
        }
    }
    
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
