//
//  ViewModel+PositionCalculation.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 5/5/23.
//

import Foundation

extension ViewModel {
    func calculateCurrentProgress() {
        guard let currentChallenge,
              let nextChallenge,
              let currentChallengeBeaconRanging = locationData[LocationDataSource(rawValue: currentChallenge.beacon)!],
              let nextChallengeBeaconRanging = locationData[LocationDataSource(rawValue: nextChallenge.beacon)!] else { return }
        
        let progress = getProgress(beacon1RSSI: currentChallengeBeaconRanging.rssi, beacon2RSSI: nextChallengeBeaconRanging.rssi)
        
        self.progress = progress
    }
    
    func getProgress(beacon1RSSI: Double, beacon2RSSI: Double) -> Double {
        let clampedBeacon1RSSI = abs(min(beacon1RSSI, -40)) - 40
        let clampedBeacon2RSSI = abs(min(beacon2RSSI, -40)) - 40
        
        let range = clampedBeacon2RSSI + clampedBeacon1RSSI
        
        guard range > 0 else { return 0.5 }
        
        let progress = 1 - clampedBeacon2RSSI / range
        
        return progress
    }
}
