//
//  RoomCaptureData.swift
//  ExploreAbility Room Scanner
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation

struct RoomCaptureImportedData: Codable {
    var walls: [[Position]]
    var usdzData: Data
}
