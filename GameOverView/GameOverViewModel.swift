//
//  GameOverViewModel.swift
//  GameOverView
//
//  Created by Jia Chen Yee on 29/5/23.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseCore

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
    
    var ref: DatabaseReference!
    
    @Published var arrivedGroups: [ArrivedGroup] = []
    
    init() {
        FirebaseApp.configure()
        
        ref = Database.database().reference()
        
        ref.child("arrivedGroup").observe(.value) { [self] snapshot in
            
            if let value = snapshot.value as? [String: Double] {
                let values = value.map { (groupName, date) in
                    ArrivedGroup(name: groupName, dateArrived: Date(timeIntervalSince1970: date))
                }.sorted { $0.dateArrived < $1.dateArrived }
                
                if arrivedGroups.count != values.count {
                    Timer.scheduledTimer(withTimeInterval: 1 + Double(arrivedGroups.count) * 0.25,
                                         repeats: false) { [self] _ in
                        arrivedGroups = values
                        playAnimation()
                    }
                }
            } else {
                print("ERROR")
            }
        }
    }
    
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
            
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                
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
