//
//  SessionInfoConsoleMessage.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

struct SessionInfoConsoleMessage: MessageContents {
    var hostID: String
    var location: Location
    
    enum CodingKeys: String, CodingKey {
        case hostID = "hid"
        case location = "l"
    }
}
