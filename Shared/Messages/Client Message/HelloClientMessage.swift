//
//  HelloClientMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct HelloClientMessage: MessageContents {
    var groupName: String
    
    enum CodingKeys: String, CodingKey {
        case groupName = "n"
    }
}
