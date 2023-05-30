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
    
    @Published var academyBeacons: [Date?]
    @Published var academyStatus: [BeaconStatus]
    
    @Published var foundationBeacons: [Date?]
    @Published var foundationStatus: [BeaconStatus]
    
    var centralManager: CBCentralManager!
    let beaconUUID = CBUUID(string: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")

    override init() {
        academyBeacons = .init(repeating: nil, count: 7)
        academyStatus = .init(repeating: .offline, count: 7)
        foundationBeacons = .init(repeating: nil, count: 7)
        foundationStatus = .init(repeating: .offline, count: 7)
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            for i in 0..<7 {
                if let academyBeaconDate = academyBeacons[i] {
                    let seconds = abs(academyBeaconDate.timeIntervalSinceNow)

                    if seconds < 1.5 {
                        if academyStatus[i] != .online {
                            academyStatus[i] = .online
                            Logger.shared.addLog(.success, "Connected to Academy \(i + 1) Beacon", imageName: "waveform")
                        }
                    } else if seconds < 5 {
                        if academyStatus[i] != .warning {
                            academyStatus[i] = .warning
                            Logger.shared.addLog(.warning, "Unstable Connection with Academy \(i + 1) Beacon", imageName: "waveform.badge.exclamationmark")
                        }
                    } else {
                        if academyStatus[i] != .error {
                            academyStatus[i] = .error
                            Logger.shared.addLog(.critical, "Lost Connection to Academy \(i + 1) Beacon", imageName: "waveform.slash")
                        }
                    }
                } else {
                    academyStatus[i] = .offline
                }

                if let foundationBeaconDate = foundationBeacons[i] {
                    let seconds = abs(foundationBeaconDate.timeIntervalSinceNow)

                    if seconds < 1.5 {
                        if foundationStatus[i] != .online {
                            foundationStatus[i] = .online
                            Logger.shared.addLog(.success, "Connected to Foundation \(i + 1) Beacon", imageName: "waveform")
                        }
                    } else if seconds < 5 {
                        if foundationStatus[i] != .warning {
                            foundationStatus[i] = .warning
                            Logger.shared.addLog(.warning, "Unstable Connection with Foundation \(i + 1) Beacon", imageName: "waveform.badge.exclamationmark")
                        }
                    } else {
                        if foundationStatus[i] != .error {
                            foundationStatus[i] = .error
                            Logger.shared.addLog(.critical, "Lost Connection to Foundation \(i + 1) Beacon", imageName: "waveform.slash")
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
}
