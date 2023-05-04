//
//  ViewModel+PositionCalculation.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 5/5/23.
//

import Foundation

extension ViewModel {
    func calculatePosition(using locationData: [LocationData], date: Date) -> IPSPosition? {
        let filteredLocationData = locationData.filter { abs($0.date.timeIntervalSinceNow) < 5 }
        
        // Check if we have at least 3 beacons
        if filteredLocationData.count < 3 {
            print("At least 3 beacons are required for trilateration")
            return nil
        }
        
        // Find the weighted centroid
        var sumWeightedX = 0.0
        var sumWeightedY = 0.0
        var sumWeights = 0.0
        
        for beacon in filteredLocationData {
            let weight = 1.0 / (beacon.distance * beacon.distance)
            sumWeightedX += beacon.position.x * weight
            sumWeightedY += beacon.position.y * weight
            sumWeights += weight
        }
        
        let centroidX = sumWeightedX / sumWeights
        let centroidY = sumWeightedY / sumWeights
        let centroid = Position(x: centroidX, y: centroidY)
        
        // Create that circle thing that mapping apps do around points
        var errorEstimate = 0.0
        
        for beacon in locationData {
            let deltaX = beacon.position.x - centroidX
            let deltaY = beacon.position.y - centroidY
            let distanceError = sqrt(deltaX * deltaX + deltaY * deltaY) - beacon.distance
            errorEstimate += distanceError * distanceError
        }
        errorEstimate = sqrt(errorEstimate / Double(locationData.count))
        
        return IPSPosition(position: centroid, error: errorEstimate, date: date, trueHeading: locationManager.heading?.trueHeading)
    }
}
