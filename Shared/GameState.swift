//
//  GameState.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import SwiftUI

let password = "346678"

enum GameState: Int, CustomStringConvertible, Codable, Equatable, Comparable {
    
    case internalTest = -100
    
    case waitingRoom = -4
    case groupSetUp = -3
    case connection = -2
    case exploring = -1
    
    case closedCaptions = 0
    case reduceMotion = 1
    case guidedAccess = 2
    case voiceOver = 3
    case textSize = 4
    
    case gameOver = 100
    
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
        case .reduceMotion:
            return "square.stack.3d.forward.dottedline"
        case .guidedAccess:
            return "lock.ipad"
        case .gameOver:
            return "checkmark.seal"
        }
    }
    
    func toColor() -> Color {
        switch self {
        case .exploring, .connection, .internalTest, .groupSetUp, .waitingRoom, .gameOver:
            return .black
        case .textSize:
            return .blue
        case .voiceOver:
            return .yellow
        case .closedCaptions:
            return .green
        case .reduceMotion:
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
        case .reduceMotion:
            return "Reduce Motion"
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
        case .gameOver:
            return "Game Over"
        }
    }
    
    var next: GameState? {
        GameState(rawValue: rawValue + 1)
    }
    
    var previous: GameState? {
        GameState(rawValue: rawValue - 1)
    }
    
    static let allChallenges: [GameState] = [
        .closedCaptions,
        .reduceMotion,
        .guidedAccess,
        .voiceOver,
        .textSize
    ]
    
    static func < (lhs: GameState, rhs: GameState) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var hints : String? {
        switch self {
        case .textSize:
            return "You might have seen this enabled on your grandparents device if they cant see clearly"
        case .voiceOver:
            return "This allows those who cannot see to use their phone by having texts read aloud"
        case .closedCaptions:
            return "This allows those who cannot hear clearly to understand the content by reading"
        case .reduceMotion:
            return "Some people may find animations distracting or annoying, this feature disables that."
        case .guidedAccess:
            return "Don’t trust the person you’re passing your phone to? Enable this feature to ensure they don’t leave the app"
        case .connection:
            return "This is just for testing only"
        default:
            return nil
        }
    }
}
