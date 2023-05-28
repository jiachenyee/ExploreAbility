//
//  GameOverViewModel.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import SwiftUI
import Foundation
import CoreMotion
import MultipeerConnectivity
import FirebaseDatabase
import FirebaseDatabaseSwift

class GameOverViewModel: NSObject, ObservableObject {
    
    @Published var state = GameOverState.ar {
        didSet {
            if state == .completed {
                complete()
            }
        }
    }
    
    var groupName: String?
    
    let motionManager = CMMotionManager()
    
    var collectedMotionData: [Double] = []
    
    var ref: DatabaseReference!
    
    var rank: Int? = 0
    var completedTeams = 0
    
    @Published var animationPercentage = 0.0
    
    override init() {
        super.init()
        startMotionUpdates()
        ref = Database.database().reference()
        startObserving()
    }
    
    func complete() {
        if groupName!.isEmpty {
            groupName = "testgroup"
        }
        ref.child("arrivedGroup").setValue([groupName! : Date.now.timeIntervalSince1970])
    }
    
    func startObserving() {
        ref.child("arrivedGroup").observe(.value) { [self] snapshot in
            // Start sequence
            let data = snapshot.value as? [String: Double] ?? [:]
            
            completedTeams = data.count - 1
            
            if state != .completed {
                rank = data.count
            } else if let latestTimestamp = data.values.sorted(by: <).last,
                      let rank {
                
                Timer.scheduledTimer(withTimeInterval: -abs(Date(timeIntervalSince1970: latestTimestamp).timeIntervalSinceNow) + 1 + Double(completedTeams - rank) * 0.25, repeats: false) { _ in
                    
                    withAnimation(.linear(duration: 0.25)) {
                        self.animationPercentage = 1
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: -abs(Date(timeIntervalSince1970: latestTimestamp).timeIntervalSinceNow) + 5 + Double(completedTeams) * 0.25, repeats: false) { _ in
                    
                    withAnimation(.linear(duration: 0.25)) {
                        self.animationPercentage = 1
                    }
                }
            }
        }
    }
    
    deinit {
        stopMotionUpdates()
    }
}
