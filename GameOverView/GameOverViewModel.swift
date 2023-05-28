//
//  GameOverViewModel.swift
//  GameOverView
//
//  Created by Jia Chen Yee on 29/5/23.
//

import Foundation
import SwiftUI

struct ArrivedGroup: Identifiable {
    var id: String {
        name
    }
    
    var name: String
    var dateArrived: Date
}

class GameOverViewModel: ObservableObject {
    
    @Published var currentState = SessionState.leaderboards
    
    @Published var circleScale = 0.0
    @Published var circleOffset = 0.0
    
    @Published var isCircleRankShown = false
    
    @Published var arrivedGroups: [ArrivedGroup] = [
        ArrivedGroup(name: "test1", dateArrived: .now),
        ArrivedGroup(name: "test2", dateArrived: .now),
        ArrivedGroup(name: "test3", dateArrived: .now),ArrivedGroup(name: "test4", dateArrived: .now),ArrivedGroup(name: "test5", dateArrived: .now),ArrivedGroup(name: "test6", dateArrived: .now),ArrivedGroup(name: "tes7", dateArrived: .now)
    ]
    
    func playAnimation() {
        withAnimation {
            currentState = .successAnimation
        }
        
        withAnimation(.easeInOut(duration: 1)) {
            circleScale = 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            
            withAnimation {
                self.isCircleRankShown = true
            }
            
            withAnimation(.spring(dampingFraction: 0.2)) {
                self.circleScale = 0.2
                self.circleOffset = -0.5
            }
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                
                withAnimation {
                    self.currentState = .leaderboards
                }
            }
        }
    }
}

enum SessionState {
    case leaderboards
    case successAnimation
}
