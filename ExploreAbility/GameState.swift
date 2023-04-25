//
//  GameState.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import SwiftUI

enum GameState: Int, CustomStringConvertible {
    case connection = -2
    case exploring = -1
    
    case textSize = 0
    case voiceOver = 1
    case closedCaptions = 2
    case voiceControl = 3
    case guidedAccess = 4
    
    func toIcon() -> String {
        switch self {
        case .exploring, .connection:
            return "questionmark"
        case .textSize:
            return "textformat.size"
        case .voiceOver:
            return "speaker.wave.3"
        case .closedCaptions:
            return "captions.bubble"
        case .voiceControl:
            return "rectangle.3.group.bubble.left"
        case .guidedAccess:
            return "lock.ipad"
        }
    }
    
    func toColor() -> Color {
        switch self {
        case .exploring, .connection:
            return .black
        case .textSize:
            return .blue
        case .voiceOver:
            return .yellow
        case .closedCaptions:
            return .green
        case .voiceControl:
            return .red
        case .guidedAccess:
            return .purple
        }
    }
    
    var description: String {
        switch self {
        case .textSize:
            return "TextSizeChallenge"
        case .voiceOver:
            return "VoiceOverChallenge"
        case .closedCaptions:
            return "ClosedCaptionChallenge"
        case .voiceControl:
            return "VoiceControlChallenge"
        case .guidedAccess:
            return "GuidedAccessChallenge"
        case .exploring:
            return "Exploring"
        case .connection:
            return "Connection"
        }
    }
}
