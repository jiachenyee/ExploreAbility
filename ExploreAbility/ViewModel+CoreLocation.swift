//
//  ViewModel+CoreLocation.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 27/4/23.
//

import Foundation
import CoreLocation
import Accelerate

extension ViewModel: CLLocationManagerDelegate {
    func startMonitoring() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first?.horizontalAccuracy)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.magneticHeading)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            switch location {
            case .academy:
                let constraint = CLBeaconIdentityConstraint(uuid: CLBeaconRegion.academyConsole.uuid, major: 1)
                
                manager.startRangingBeacons(satisfying: constraint)
            case .foundation:
                let constraint = CLBeaconIdentityConstraint(uuid: CLBeaconRegion.foundationConsole.uuid, major: 2)
                
                manager.startRangingBeacons(satisfying: constraint)
            }
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
        guard let beacon = beacons.first else { return }
        
        guard beacon.rssi != 0 else { return }
        
        rssis.append(Double(beacon.rssi))
        
        let runningAverageDatapoints = rssis[max(0, rssis.count - 20)...]
        
        let runningAverage = runningAverageDatapoints.reduce(0, +) / Double(runningAverageDatapoints.count)
                              
        
//        print(runningAverage)
        print(beacon.proximity.rawValue, beacon.accuracy)
//    case unknown = 0
//    case immediate = 1 <0.5m
//    case near = 2 <14.5m
//    case far = 3
        
//        print(beacon.accuracy)
    }
}
