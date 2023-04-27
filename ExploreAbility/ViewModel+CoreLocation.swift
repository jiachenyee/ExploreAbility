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
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
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
        print(beaconRegion?.uuid)

        if state == .inside {
            print("inside")
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
        print(beacon.rssi)
//        print(beacon.proximity.rawValue)
//    case unknown = 0
//    case immediate = 1 <0.5m
//    case near = 2 <14.5m
//    case far = 3
        
        print(calculateAccuracy(txPower: -47, rssi: Double(beacon.rssi)))
        beacon.rssi
        print(beacon.accuracy)
    }
    
    func calculateAccuracy(txPower: Double, rssi: Double) -> Double {
        if rssi == 0 {
            return -1 // if we cannot determine accuracy, return -1.
        }
        
        return pow(10, ((-56-rssi)/(10 * 2))) * 3.2808
    }
}
