//
//  GameState+Validation.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 4/5/23.
//

import Foundation
import UIKit

extension GameState {
    func performPreconditionCheck() -> Bool {
        switch self {
        case .internalTest, .connection, .exploring, .groupSetUp, .waitingRoom:
            return false
        case .voiceOver:
            return !UIAccessibility.isVoiceOverRunning
        case .textSize:
            return UIApplication.shared.preferredContentSizeCategory == .medium || UIApplication.shared.preferredContentSizeCategory == .large
        case .closedCaptions:
            return !UIAccessibility.isClosedCaptioningEnabled
        case .reduceMotion:
            return !UIAccessibility.isReduceMotionEnabled
        case .guidedAccess:
            return !UIAccessibility.isGuidedAccessEnabled
        }
    }
}
