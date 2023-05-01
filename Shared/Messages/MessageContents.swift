//
//  MessageContents.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation

typealias MessageContents = Codable

enum ConsoleMessageCode: Int, Codable {
    case sessionInfo = 2
    case positionResponse = 4
    case startGame = 5
    case nextChallenge = 7
}
