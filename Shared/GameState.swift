//
//  GameState.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import SwiftUI

enum GameState: Int, CustomStringConvertible, Codable, Equatable {
    case internalTest = -100
    
    case waitingRoom = -4
    case groupSetUp = -3
    case connection = -2
    case exploring = -1
    
    case textSize = 0
    case voiceOver = 1
    case closedCaptions = 2
    case reducedMotion = 3
    case guidedAccess = 4
    
    func toIcon() -> String {
        switch self {
        case .exploring, .connection, .internalTest, .groupSetUp, .waitingRoom:
            return "questionmark"
        case .textSize:
            return "textformat.size"
        case .voiceOver:
            return "speaker.wave.3"
        case .closedCaptions:
            return "captions.bubble"
        case .reducedMotion:
            return "square.stack.3d.forward.dottedline"
        case .guidedAccess:
            return "lock.ipad"
        }
    }
    
    func toColor() -> Color {
        switch self {
        case .exploring, .connection, .internalTest, .groupSetUp, .waitingRoom:
            return .black
        case .textSize:
            return .blue
        case .voiceOver:
            return .yellow
        case .closedCaptions:
            return .green
        case .reducedMotion:
            return .red
        case .guidedAccess:
            return .purple
        }
    }
    
    var description: String {
        switch self {
        case .textSize:
            return "Dynamic Text"
        case .voiceOver:
            return "VoiceOver"
        case .closedCaptions:
            return "Closed Caption"
        case .reducedMotion:
            return "Reduced Motion"
        case .guidedAccess:
            return "Guided Access"
        case .exploring:
            return "Exploring"
        case .connection:
            return "Connection"
        case .internalTest:
            return "Test"
        case .groupSetUp:
            return "Group Setup"
        case .waitingRoom:
            return "Waiting Room"
        }
    }
    
    static let all: [GameState] = [.textSize, .voiceOver, .guidedAccess, .reducedMotion, .closedCaptions]
}
