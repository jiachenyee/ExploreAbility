//
//  ClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct ClientMessage: Codable {
    private(set) var messageCode: MessageCode
    
    var payload: DecodedMessageContents
    
    init(payload: DecodedMessageContents) {
        self.payload = payload
        
        switch payload {
        case .hello(_):
            messageCode = .hello
        case .heartbeat(_):
            messageCode = .heartbeat
        case .challengeStarted(_):
            messageCode = .challengeStarted
        case .challengeFinished(_):
            messageCode = .challengeFinished
        }
    }
    
    enum MessageCode: Int, Codable {
        case hello = 1
        case heartbeat = 3
        case challengeStarted = 5
        case challengeFinished = 7
    }
    
    enum DecodedMessageContents {
        case hello(HelloClientMessage)
        case heartbeat(HeartbeatClientMessage)
        case challengeStarted(ChallengeStartedClientMessage)
        case challengeFinished(ChallengeFinishedClientMessage)
    }
    
    enum CodingKeys: String, CodingKey {
        case messageCode = "c"
        case payload = "p"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageCode, forKey: .messageCode)
        
        switch payload {
        case .hello(let payloadData):
            try container.encode(payloadData, forKey: .payload)
        case .heartbeat(let payloadData):
            try container.encode(payloadData, forKey: .payload)
        case .challengeStarted(let payloadData):
            try container.encode(payloadData, forKey: .payload)
        case .challengeFinished(let payloadData):
            try container.encode(payloadData, forKey: .payload)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.messageCode = try container.decode(MessageCode.self, forKey: .messageCode)
        
        switch messageCode {
        case .hello:
            self.payload = .hello(try container.decode(HelloClientMessage.self, forKey: .payload))
        case .heartbeat:
            self.payload = .heartbeat(try container.decode(HeartbeatClientMessage.self, forKey: .payload))
        case .challengeStarted:
            self.payload = .challengeStarted(try container.decode(ChallengeStartedClientMessage.self, forKey: .payload))
        case .challengeFinished:
            self.payload = .challengeFinished(try container.decode(ChallengeFinishedClientMessage.self, forKey: .payload))
        }
    }
    
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
