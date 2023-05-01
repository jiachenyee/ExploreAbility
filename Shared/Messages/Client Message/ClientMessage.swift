//
//  ClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct ClientMessage: Codable {
    var messageCode: MessageCode
    
    var payload: DecodedMessageContents
    
    enum MessageCode: Int, Codable {
        case hello = 1
        case heartbeat = 3
        case challengeCompletion = 6
    }
    
    enum DecodedMessageContents {
        case hello(HelloClientMessage)
        case heartbeat(HeartbeatClientMessage)
        case challengeCompletion(ChallengeCompletionClientMessage)
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
        case .challengeCompletion(let payloadData):
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
        case .challengeCompletion:
            self.payload = .challengeCompletion(try container.decode(ChallengeCompletionClientMessage.self, forKey: .payload))
        }
    }
}
