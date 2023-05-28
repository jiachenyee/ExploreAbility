//
//  ChallengeHints.swift
//  ExploreAbility
//
//  Created by Muhammad Tafani Rabbani on 28/04/23.
//
import Foundation
enum ChallengeHints : String,CaseIterable,Identifiable{
    var id: String { return self.rawValue }
    
    case singing = "Guess the Song"
    case ball = "Guess the Ball"
    
    var description : String {
        switch self{
        case .singing:
            return "What is Mario's favorite song?"
        case .ball:
            return "Guess how many balls are there?"
        }
    }
}
