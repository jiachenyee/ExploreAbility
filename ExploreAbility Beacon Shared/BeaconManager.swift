//
//  BeaconManager.swift
//  ExploreAbility Beacon
//
//  Created by Jia Chen Yee on 26/4/23.
//

import Foundation
import CoreBluetooth
import CoreLocation

class BeaconManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager!
    var beaconRegion: CLBeaconRegion!
    var peripheralData: NSDictionary!
    
    @Published var isActive = false
    
    override init() {
        super.init()
        
    }
    
    func setUp(region: CLBeaconRegion) {
        beaconRegion = region
        
        peripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(peripheralData as! [String : Any]?)
            isActive = true
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
            isActive = false
        }
    }
}
