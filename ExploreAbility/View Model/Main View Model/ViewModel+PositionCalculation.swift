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
        
        if nextChallengeInitialRSSI == nil {
            nextChallengeInitialRSSI = nextChallengeBeaconRanging.rssi
        }
        
        guard let nextChallengeInitialRSSI else { return }
        
        let progress = getProgress(initialRSSI: nextChallengeInitialRSSI, currentRSSI: nextChallengeBeaconRanging.rssi)
        
        self.progress = progress
        
        print(progress)
        
    }
    
    func getProgress(initialRSSI: Double, currentRSSI: Double) -> Double {
        let clampedInitialRSSI = abs(min(initialRSSI, -40)) - 40
        let clampedCurrentRSSI = abs(min(currentRSSI, -40)) - 40
        
        let value = (clampedInitialRSSI - clampedCurrentRSSI) / clampedInitialRSSI
        
        return max(min(value, 1), 0)
    }
}
