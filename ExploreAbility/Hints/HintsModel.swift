//
//  HintsModel.swift
//  ExploreAbility
//
//  Created by Muhammad Tafani Rabbani on 27/04/23.
//

import Foundation
import SwiftUI

struct HintsModel{
    
    enum DetentCases{
        case smallOnly
        case mediumSmallOnly
        case allAvailable
    }
    
    var hintCounter = 2
    var hintShow = false {
        didSet{
            currentDetentCase = .mediumSmallOnly
        }
    }
    var selectedDetent: PresentationDetent = .height(200)
    var selectedChallenge: ChallengeHints = .singing
    var challenge : [ChallengeHints] = [.singing,.ball]
    var listDetent: [PresentationDetent] = [.height(200)]
    var isHintShow : [GameState:Int?] = [:]
    var currentDetentCase : DetentCases = .smallOnly {
        didSet {
            switch currentDetentCase {
            case .smallOnly:
                self.listDetent = [.height(200)]
            case .mediumSmallOnly:
                listDetent = [.height(200),.height(420)]
            case .allAvailable:
                listDetent = [.height(420),.height(800)]
            }
            self.selectedDetent = self.listDetent.last ?? .height(200)
        }
    }
    
    
 
}
