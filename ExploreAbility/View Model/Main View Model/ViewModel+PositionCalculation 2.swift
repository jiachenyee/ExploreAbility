//
//  ViewModel+PositionCalculation.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 5/5/23.
//

import Foundation

extension ViewModel {
    func calculateCurrentProgress() {
        guard let nextChallenge,
              let nextChallengeBeaconRanging = locationData[LocationDataSource(rawValue: nextChallenge.beacon)!] else { return }
        
        print("HELP")
        switch nextChallengeBeaconRanging.accuracy {
        case -1: progress = 1
        case -2, -3: progress = 0
        default:
            if nextChallengeInitialAccuracy == nil {
                nextChallengeInitialAccuracy = nextChallengeBeaconRanging.accuracy
            }
            
            guard let nextChallengeInitialAccuracy else { return }
            
            let progress = getProgress(initialRSSI: nextChallengeInitialAccuracy, currentRSSI: nextChallengeBeaconRanging.accuracy)
            
            self.progress = progress
        }
        
        print(progress)
        
    }
    
    func getProgress(initialRSSI: Double, currentRSSI: Double) -> Double {
        let clampedInitialRSSI = initialRSSI
        let clampedCurrentRSSI = currentRSSI
        
        let value = (clampedInitialRSSI - clampedCurrentRSSI) / clampedInitialRSSI
        
        return max(min(value, 1), 0)
    }
}
