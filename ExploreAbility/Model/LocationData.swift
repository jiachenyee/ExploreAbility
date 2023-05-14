//
//  LocationData.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 3/5/23.
//

import Foundation

struct LocationData {
    var position: Position
    var rssi: Double
    var date: Date
}

enum LocationDataSource: Int, Hashable {
    case gps = 0
    
    case beacon1 = 1
    case beacon2 = 2
    case beacon3 = 3
    case beacon4 = 4
    case beacon5 = 5
    case beacon6 = 6
    case beacon7 = 7
}
