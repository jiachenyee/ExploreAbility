//
//  MapCustomisation.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 30/4/23.
//

import Foundation

struct MapCustomisations: Equatable {
    var focusedGroup: Group?
    var followingFocusedGroup = false
    
    var showBeacons = true
    var animateBeacons = true
    
    var showGrid = true
    
    var showGroups = true
}
