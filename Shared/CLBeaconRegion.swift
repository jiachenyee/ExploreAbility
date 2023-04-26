//
//  CLBeaconRegion.swift
//  ExploreAbility Beacon
//
//  Created by Jia Chen Yee on 26/4/23.
//

import Foundation
import CoreLocation

extension CLBeaconRegion {
    static let academyConsole = CLBeaconRegion(uuid: UUID(uuidString: "9AEFDF77-45E9-49E1-BD65-BB09C723043D")!, major: 1, minor: 0, identifier: "app.jiachen.exploreability.academy.0")
    static let academy1 = CLBeaconRegion(uuid: UUID(uuidString: "1D8123E8-E703-4FE8-AB73-14EFB3B3EA40")!, major: 1, minor: 1, identifier: "app.jiachen.exploreability.academy.1")
    static let academy2 = CLBeaconRegion(uuid: UUID(uuidString: "EA7BEC46-307D-48D3-8877-ABB812B14379")!, major: 1, minor: 2, identifier: "app.jiachen.exploreability.academy.2")
    static let academy3 = CLBeaconRegion(uuid: UUID(uuidString: "165D50FE-DDF9-4CD1-93FC-DED0590E10FF")!, major: 1, minor: 3, identifier: "app.jiachen.exploreability.academy.3")
    static let academy4 = CLBeaconRegion(uuid: UUID(uuidString: "BCE00D6A-717E-4173-A57C-254900089012")!, major: 1, minor: 4, identifier: "app.jiachen.exploreability.academy.4")
    static let academy5 = CLBeaconRegion(uuid: UUID(uuidString: "B06C1BAF-78A1-460E-AD36-8C5095734DD8")!, major: 1, minor: 5, identifier: "app.jiachen.exploreability.academy.5")
    
    static let foundationConsole = CLBeaconRegion(uuid: UUID(uuidString: "1E48FA39-9D93-449A-87D1-7A08537DF2B5")!, major: 2, minor: 0, identifier: "app.jiachen.exploreability.foundations.0")
    static let foundation1 = CLBeaconRegion(uuid: UUID(uuidString: "6E81D4BB-C2C0-46F0-959D-FB539AB28B61")!, major: 2, minor: 1, identifier: "app.jiachen.exploreability.foundations.1")
    static let foundation2 = CLBeaconRegion(uuid: UUID(uuidString: "13462DDC-D0B1-49B7-AFA8-7BA8F7B37763")!, major: 2, minor: 2, identifier: "app.jiachen.exploreability.foundations.2")
    static let foundation3 = CLBeaconRegion(uuid: UUID(uuidString: "243AB178-E438-4214-A389-F8144474BF03")!, major: 2, minor: 3, identifier: "app.jiachen.exploreability.foundations.3")
    static let foundation4 = CLBeaconRegion(uuid: UUID(uuidString: "687D8C28-835E-4715-8DFC-FEB087F7B42F")!, major: 2, minor: 4, identifier: "app.jiachen.exploreability.foundations.4")
    static let foundation5 = CLBeaconRegion(uuid: UUID(uuidString: "54A9AC00-B4BA-4D58-BA55-9FC103CD2E9A")!, major: 2, minor: 5, identifier: "app.jiachen.exploreability.foundations.5")
    
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
