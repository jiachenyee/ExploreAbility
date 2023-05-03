//
//  GPSPosition.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 3/5/23.
//

import Foundation

struct GPSPosition: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
}
