//
//  CLBeaconRegion.swift
//  ExploreAbility Beacon
//
//  Created by Jia Chen Yee on 26/4/23.
//

import Foundation
import CoreLocation

extension CLBeaconRegion {
    static let academyConsole = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 1, minor: 0, identifier: "app.jiachen.exploreability.academy.0")
    static let academy1 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 1, minor: 1, identifier: "app.jiachen.exploreability.academy.1")
    static let academy2 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 1, minor: 2, identifier: "app.jiachen.exploreability.academy.2")
    static let academy3 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 1, minor: 3, identifier: "app.jiachen.exploreability.academy.3")
    static let academy4 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 1, minor: 4, identifier: "app.jiachen.exploreability.academy.4")
    static let academy5 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 1, minor: 5, identifier: "app.jiachen.exploreability.academy.5")
    
    static let foundationConsole = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 2, minor: 0, identifier: "app.jiachen.exploreability.foundations.0")
    static let foundation1 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 2, minor: 1, identifier: "app.jiachen.exploreability.foundations.1")
    static let foundation2 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 2, minor: 2, identifier: "app.jiachen.exploreability.foundations.2")
    static let foundation3 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 2, minor: 3, identifier: "app.jiachen.exploreability.foundations.3")
    static let foundation4 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 2, minor: 4, identifier: "app.jiachen.exploreability.foundations.4")
    static let foundation5 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 2, minor: 5, identifier: "app.jiachen.exploreability.foundations.5")
    
    static let allFoundationBeacons = [
        foundationConsole,
        foundation1,
        foundation2,
        foundation3,
        foundation4,
        foundation5
    ]
    
    static let allAcademyBeacons = [
        academyConsole,
        academy1,
        academy2,
        academy3,
        academy4,
        academy5
    ]
}
