//
//  LoggerViewModel.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation
import SwiftUI

class LoggerViewModel: ObservableObject {
    @Published var log: [Log] = []
    
    func addLog(_ type: LogType, _ text: String, imageName: String) {
        log.insert(Log(text: text, imageName: imageName, type: type), at: 0)
    }
    
    func addLog(_ text: String, imageName: String) {
        log.insert(Log(text: text, imageName: imageName, type: .normal), at: 0)
    }
}
