//
//  BeaconStatus.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 2/5/23.
//

import Foundation
import SwiftUI

enum BeaconStatus {
    case online
    case warning
    case error
    case offline
    
    func toColor() -> Color {
        switch self {
        case .online:
            return .green
        case .warning:
            return .yellow
        case .error:
            return .red
        case .offline:
            return .gray
        }
    }
}
