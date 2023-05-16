//
//  ViewModel+CoreLocation.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 27/4/23.
//

import Foundation
import CoreLocation

extension ViewModel: CLLocationManagerDelegate {
    func startMonitoring() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        
    }
    func calculateLocalPosition(origin: GPSPosition, target: GPSPosition) -> Position {
        // Convert latitude and longitude to radians
        let originLatInRadians = origin.latitude * Double.pi / 180.0
        let originLongInRadians = origin.longitude * Double.pi / 180.0
        
        let targetLatInRadians = target.latitude * Double.pi / 180.0
        let targetLongInRadians = target.longitude * Double.pi / 180.0
        
        // Calculate distance and bearing between origin and target in meters
        let R = 6371000.0 // radius of the Earth in meters
        let deltaLatInRadians = targetLatInRadians - originLatInRadians
        let deltaLongInRadians = targetLongInRadians - originLongInRadians
        let a = sin(deltaLatInRadians/2) * sin(deltaLatInRadians/2) + cos(originLatInRadians) * cos(targetLatInRadians) * sin(deltaLongInRadians/2) * sin(deltaLongInRadians/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let distanceInMeters = R * c
        
        let bearing = atan2(sin(deltaLongInRadians) * cos(targetLatInRadians), cos(originLatInRadians) * sin(targetLatInRadians) - sin(originLatInRadians) * cos(targetLatInRadians) * cos(deltaLongInRadians))
        
        // Calculate x and y coordinates in the local coordinate system
        let x = distanceInMeters * cos(bearing)
        let y = distanceInMeters * sin(bearing)
        
        return Position(x: x, y: y)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            let constraint = CLBeaconIdentityConstraint(uuid: CLBeaconRegion.academyConsole.uuid, major: 1)
            manager.startRangingBeacons(satisfying: constraint)
            
            let anotherConstraint = CLBeaconIdentityConstraint(uuid: CLBeaconRegion.foundationConsole.uuid, major: 2)
            manager.startRangingBeacons(satisfying: anotherConstraint)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let beaconRegion = region as? CLBeaconRegion

        if state == .inside {
            manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        } else {
            manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        }
        manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didRange beacons: [CLBeacon],
                         satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        guard let sessionInfo else { return }
        
        for beacon in beacons where sessionInfo.location.rawValue == beacon.major.intValue {
            print(beacon.major)
            
            guard let locationDataSource = LocationDataSource(rawValue: beacon.minor.intValue),
                  let localBeaconPosition = sessionInfo.beaconLocations[beacon.minor.intValue - 1],
                  beacon.accuracy > 0 else { return }
            
//            switch beacon.proximity {
//            case .immediate:
//                distance = 1
//            case .near:
//                distance = 14
//            case .far:
//                distance = 50
//            default: break
//            }
            
            locationData[locationDataSource] = LocationData(position: localBeaconPosition,
                                                            rssi: Double(beacon.rssi), date: .now)
        }
        
//    case unknown = 0
//    case immediate = 1 <0.5m
//    case near = 2 <14.5m
//    case far = 3
        
        
    }
}
