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
    
    @Published var isActive = false {
        didSet {
            if !isActive {
                peripheralManager.stopAdvertising()
            }
        }
    }
    
    override init() {
        super.init()
        
    }
    
    func setUp(region: CLBeaconRegion) {
        beaconRegion = region
        
        #if os(macOS)
        let peripheralData = NSMutableDictionary()
        
        var dataToSend = withUnsafeBytes(of: beaconRegion.uuid.uuid) { Data($0) }
        
        dataToSend.append(withUnsafeBytes(of: beaconRegion.major!.uint16Value.bigEndian) { Data($0) })
        dataToSend.append(withUnsafeBytes(of: beaconRegion.minor!.uint16Value.bigEndian) { Data($0) })
        
        dataToSend.append(0xC5)
        
        peripheralData.setValue(dataToSend, forKey: "kCBAdvDataAppleBeaconKey")
        
        self.peripheralData = peripheralData
        #else
        peripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        #endif
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(peripheralData as! [String : Any]?)
            isActive = true
        } else if peripheral.state == .poweredOff {
            isActive = false
        }
    }
}
