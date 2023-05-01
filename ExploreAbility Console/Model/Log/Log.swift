//
//  Log.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation
import SwiftUI

struct Log: Identifiable {
    var id = UUID()
    var text: String
    var date: Date = .now
    
    var imageName: String
    
    var type: LogType
}
