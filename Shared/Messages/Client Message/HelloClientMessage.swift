//
//  HelloClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct HelloClientMessage: MessageContents {
    var groupName: String
    
    var initialBeacon: Int
    var nextBeacon: Int
    
    enum CodingKeys: String, CodingKey {
        case groupName = "n"
        case initialBeacon = "ib"
        case nextBeacon = "nb"
    }
}
