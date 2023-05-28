//
//  GameState.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import SwiftUI

enum GameState: Int, CustomStringConvertible {
    case internalTest = -100
    
    case connection = -2
    case exploring = -1
    
    case textSize = 0
    case voiceOver = 1
    case closedCaptions = 2
    case reducedMotion = 3
    case guidedAccess = 4
    
    func toIcon() -> String {
        switch self {
        case .exploring, .connection, .internalTest:
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
        case .exploring, .connection, .internalTest:
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
        }
    }
    var hints : String? {
        switch self {
        case .textSize:
            return "You might have seen this enabled on your grandparents device if they cant see clearly"
        case .voiceOver:
            return "This allows those who cannot see to use their phone by having texts read aloud"
        case .closedCaptions:
            return "This allows those who cannot hear clearly to understand the content by reading"
        case .reducedMotion:
            return "Some people may find animations distracting or annoying, this feature disables that."
        case .guidedAccess:
            return "Don’t trust the person you’re passing your phone to? Enable this feature to ensure they don’t leave the app"
        case .connection:
            return "This is just for testing only"
        default:
            return nil
        }
    }
    
    func performPreconditionCheck() -> Bool {
        switch self {
        case .internalTest, .connection, .exploring:
            return false
        case .voiceOver:
            return !UIAccessibility.isVoiceOverRunning
        case .textSize:
            return UIApplication.shared.preferredContentSizeCategory == .medium || UIApplication.shared.preferredContentSizeCategory == .large
        case .closedCaptions:
            return !UIAccessibility.isClosedCaptioningEnabled
        case .reducedMotion:
            return !UIAccessibility.isReduceMotionEnabled
        case .guidedAccess:
            return !UIAccessibility.isGuidedAccessEnabled
        }
    }
    
    static let all: [GameState] = [.textSize, .voiceOver, .guidedAccess, .reducedMotion, .closedCaptions]
}
