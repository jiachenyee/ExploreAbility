//
//  LogType.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation
import SwiftUI

enum LogType {
    case normal
    case critical
    case warning
    case success
    
    func toTextColor() -> Color {
        switch self {
        case .normal:
            return .primary
        case .critical:
            return .white
        case .warning:
            return .black
        case .success:
            return .black
        }
    }
    
    func toBackground() -> Color {
        switch self {
        case .normal:
            return .clear
        case .critical:
            return .red
        case .warning:
            return .yellow
        case .success:
            return .green
        }
    }
}
