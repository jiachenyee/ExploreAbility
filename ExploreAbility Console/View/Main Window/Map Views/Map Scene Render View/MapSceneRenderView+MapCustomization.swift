//
//  MapSceneRenderView+MapCustomization.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import SceneKit

extension MapSceneRenderView {
    func updateMapCustomization(_ oldValue: MapCustomisations?) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        
        beaconGroupNode.opacity = mapCustomizations.showBeacons ? 1 : 0
        gridNode.opacity = mapCustomizations.showGrid ? 1 : 0
        groupsGroupNode.opacity = mapCustomizations.showGroups ? 1 : 0
        
        if mapCustomizations.animateBeacons != oldValue?.animateBeacons {
            beaconGroupNode.childNodes.forEach {
                $0.childNodes.first?.isHidden = !mapCustomizations.animateBeacons
            }
        }
        
        SCNTransaction.commit()
    }
}
