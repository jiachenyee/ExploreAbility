//
//  GPSPosition.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 3/5/23.
//

import Foundation
import CoreLocation

struct GPSPosition: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(location: CLLocationCoordinate2D) {
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}
