//
//  GameOverViewModel+CoreMotion.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import Foundation
import CoreMotion

extension GameOverViewModel {
    func startMotionUpdates() {
        motionManager.startAccelerometerUpdates(to: .main) { [self] data, error in
            guard let data = data else { return }
            
            collectedMotionData.append(data.acceleration.x + data.acceleration.y + data.acceleration.z)
            
            let duration = 3
            let sampleCount = duration * 100
            
            if data.acceleration.z < -1 && -0.005..<0.005 ~= data.acceleration.x {
                if collectedMotionData.count > sampleCount {
                    if abs(collectedMotionData.last! - collectedMotionData[collectedMotionData.count - sampleCount]) < 0.001 {
                        
                        if state == .scanning {
                            state = .completed
                            
                            stopMotionUpdates()
                        }
                    }
                }
            }
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}
