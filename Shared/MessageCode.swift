//
//  CommunicationCode.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

enum ConsoleMessageCode: Int, Codable {
    case sessionInfo = 2
    case positionResponse = 4
    case startGame = 5
    case nextChallenge = 7
}

struct ClientMessage: Codable {
    var messageCode: MessageCode
    
    var payload: any ClientMessageContents
    
    enum MessageCode: Int, Codable {
        case hello = 1
        case heartbeat = 3
        case challengeCompletion = 6
    }
    
    enum CodingKeys: String, CodingKey {
        case messageCode = "c"
        case payload = "p"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageCode, forKey: .messageCode)
        try container.encode(payload, forKey: .payload)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.messageCode = try container.decode(MessageCode.self, forKey: .messageCode)
        
        switch messageCode {
        case .hello:
            self.payload = try container.decode(HelloClientMessage.self, forKey: .payload)
        case .heartbeat:
            self.payload = try container.decode(HeartbeatClientMessage.self, forKey: .payload)
        case .challengeCompletion:
            self.payload = try container.decode(ChallengeCompletionClientMessage.self, forKey: .payload)
        }
    }
}

protocol ClientMessageContents: Codable {
    
}

struct HelloClientMessage: ClientMessageContents {
    var groupName: String
}

struct HeartbeatClientMessage: ClientMessageContents {
    var beaconDistances: [BeaconProximity]
    
    enum BeaconProximity: Int, Codable {
        case unknown = 0
        case immediate = 1
        case near = 2
        case far = 3
    }

}

struct ChallengeCompletionClientMessage: ClientMessageContents {
    
}
