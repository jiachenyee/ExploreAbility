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
        let uuid = UUID(uuidString: "CB212A4E-6351-4A71-AB33-579B5E8C41ED")!
        let major: CLBeaconMajorValue = 1
        let minor: CLBeaconMinorValue = 1
        
        let beaconID = "app.jiachen.exploreability"
        
        beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: beaconID)
        
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
