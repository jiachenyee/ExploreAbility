//
//  BeaconStatusViewModel.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Cocoa
import Foundation
import CoreBluetooth

class BeaconStatusViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
    
    var logger: LoggerViewModel!
    
    @Published var academyBeacons: [Date?]
    @Published var academyStatus: [BeaconStatus]
    
    @Published var foundationBeacons: [Date?]
    @Published var foundationStatus: [BeaconStatus]
    
    var centralManager: CBCentralManager!
    let beaconUUID = CBUUID(string: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")

    override init() {
        academyBeacons = .init(repeating: nil, count: 5)
        academyStatus = .init(repeating: .offline, count: 5)
        foundationBeacons = .init(repeating: nil, count: 5)
        foundationStatus = .init(repeating: .offline, count: 5)
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            for i in 0..<5 {
                if let academyBeaconDate = academyBeacons[i] {
                    let seconds = abs(academyBeaconDate.timeIntervalSinceNow)

                    if seconds < 1 {
                        if academyStatus[i] != .online {
                            academyStatus[i] = .online
                            logger.addLog(.success, "Connected to Academy \(i + 1) Beacon", imageName: "waveform")
                        }
                    } else if seconds < 5 {
                        if academyStatus[i] != .warning {
                            academyStatus[i] = .warning
                            logger.addLog(.warning, "Unstable Connection with Academy \(i + 1) Beacon", imageName: "waveform.badge.exclamationmark")
                        }
                    } else {
                        if academyStatus[i] != .error {
                            academyStatus[i] = .error
                            logger.addLog(.critical, "Lost Connection to Academy \(i + 1) Beacon", imageName: "waveform.slash")
                        }
                    }
                } else {
                    academyStatus[i] = .offline
                }

                if let foundationBeaconDate = foundationBeacons[i] {
                    let seconds = abs(foundationBeaconDate.timeIntervalSinceNow)

                    if seconds < 1 {
                        if foundationStatus[i] != .online {
                            foundationStatus[i] = .online
                            logger.addLog(.success, "Connected to Foundation \(i + 1) Beacon", imageName: "waveform")
                        }
                    } else if seconds < 5 {
                        if foundationStatus[i] != .warning {
                            foundationStatus[i] = .warning
                            logger.addLog(.warning, "Unstable Connection with Foundation \(i + 1) Beacon", imageName: "waveform.badge.exclamationmark")
                        }
                    } else {
                        if foundationStatus[i] != .error {
                            foundationStatus[i] = .error
                            logger.addLog(.critical, "Lost Connection to Foundation \(i + 1) Beacon", imageName: "waveform.slash")
                        }
                    }
                } else {
                    foundationStatus[i] = .offline
                }
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScanningForBeacons()
            startMonitoring()
        default:
            print("Central manager is not powered on.")
        }
    }
    
    func startScanningForBeacons() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    
        guard let adData: Data = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
              isBeacon(using: adData) else { return }
        
        let beacon = getBeaconInfo(from: adData)
        
        guard beacon.uuid == .iBeacon else { return }
        
        if beacon.major == 1 {
            academyBeacons[Int(beacon.minor) - 1] = .now
        } else {
            foundationBeacons[Int(beacon.minor) - 1] = .now
        }
    }
    
    func isBeacon(using advertismentData: Data) -> Bool {
        let expectingBytes: [UInt8] = [0x4c, 0x00, 0x02, 0x15]
        let expectingData = Data(bytes: expectingBytes, count: expectingBytes.count)
        
        if advertismentData.count > expectingData.count {
            if advertismentData.subdata(in: 0..<expectingData.count) == expectingData {
                return true
            }
        }
        
        return false
    }
    
    func getBeaconInfo(from data: Data) -> ReceivedBeaconInfo {
        let uuid = data[4..<20].withUnsafeBytes { NSUUID(uuidBytes: $0.baseAddress!.assumingMemoryBound(to: UInt8.self)) as UUID }
        
        let major: UInt16 = data[20..<22].withUnsafeBytes { $0.load(as: UInt16.self).bigEndian }
        let minor: UInt16 = data[22..<24].withUnsafeBytes { $0.load(as: UInt16.self).bigEndian }
        let power: Int8 = data[24..<25].withUnsafeBytes { $0.load(as: Int8.self) }
        
        return ReceivedBeaconInfo(uuid: uuid, major: major, minor: minor, power: power)
    }

    struct ReceivedBeaconInfo {
        var uuid: UUID
        var major: UInt16
        var minor: UInt16
        var power: Int8
    }

    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            startMonitoring()
//        } else {
//            print("Bye")
//        }
//    }
    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID], serviceUUIDs.contains(beaconUUID) {
//            print("iBeacon found: \(peripheral.name ?? "unknown") with RSSI: \(RSSI)")
//        }
//
//        print("EJIFuhisvc")
//        if let iBeacon = advertisementData["kCBAdvDataAppleBeaconKey"] {
//            print(iBeacon)
//        }
//
//        print("NOT")
        
//        if advertisementData.keys.contains(where: {
//            $0.lowercased().contains("key")
//        }) {
//            print("THIS")
//        }
//
//        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
//
//
//            let iBeaconPrefix: UInt16 = 0x004C
//            let iBeaconPrefixData = Data([UInt8(iBeaconPrefix >> 8), UInt8(iBeaconPrefix & 0xFF)])
//
//            // Check if the advertisement data contains iBeacon prefix
//            guard manufacturerData.count >= 25,
//                  manufacturerData.prefix(upTo: iBeaconPrefixData.count) == iBeaconPrefixData else {
//                return
//            }
//
//            // Decode iBeacon data
//            let major = UInt16(bigEndian: manufacturerData[18...19].withUnsafeBytes { $0.load(as: UInt16.self) })
//            let minor = UInt16(bigEndian: manufacturerData[20...21].withUnsafeBytes { $0.load(as: UInt16.self) })
//            let uuidBytes = manufacturerData[2...17]
//            let uuidString = uuidBytes.map { String(format: "%02X", $0) }.joined()
//            let uuid = UUID(uuidString: uuidString)
//
//            print("iBeacon found:")
//            print("UUID: \(uuid?.uuidString ?? "Invalid UUID")")
//            print("Major: \(major)")
//            print("Minor: \(minor)")
//        }
//    }
    
//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        let beaconRegion = region as? CLBeaconRegion
//        print("beacon detected")
//        if state == .inside {
//            manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
//        } else {
//            manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
//        }
//        manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
//    }
//
//    func locationManager(_ manager: CLLocationManager,
//                         didRange beacons: [CLBeacon],
//                         satisfying beaconConstraint: CLBeaconIdentityConstraint) {
//        print("HELLO")
//        for beacon in beacons {
//            if beacon.major == 1 {
//                academyBeacons[Int(truncating: beacon.minor) - 1] = .now
//            } else {
//                foundationBeacons[Int(truncating: beacon.major) - 1] = .now
//            }
//        }
//    }
}
