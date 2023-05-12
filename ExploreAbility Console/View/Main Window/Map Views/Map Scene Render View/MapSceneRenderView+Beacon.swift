//
//  MapSceneRenderView+Beacon.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import SceneKit

extension MapSceneRenderView {
    func setUpBeaconNodes() {
        for i in 0..<7 {
            let beaconNode = createBeaconNode()
            beaconNode.name = "Beacon \(i + 1)"
            beaconGroupNode.addChildNode(beaconNode)
        }
    }
    
    fileprivate func createBeaconNode() -> SCNNode {
        let beacon = SCNSphere(radius: 0.25)
        beacon.firstMaterial?.diffuse.contents = NSColor.systemBlue
        
        let beaconNode = SCNNode(geometry: beacon)
        beaconNode.position = .init(0, 1, 0)
        
        let light = SCNLight()
        light.type = .omni
        light.areaType = .polygon
        
        light.intensity = 0.75
        
        light.color = NSColor.blue
        
        beacon.firstMaterial?.emission.contents = NSColor.systemBlue
        
        beaconNode.light = light

        createBeaconAnimation(beaconNode)
        
        beaconNode.isHidden = true
        
        return beaconNode
    }
    
    fileprivate func createBeaconAnimation(_ node: SCNNode) {
        let scaleAndOpacity = SCNAction.repeatForever(
            .sequence([
                .group([
                    .scale(to: 1.5, duration: 1)
                ]),
                .group([
                    .scale(to: 1, duration: 1)
                ])
            ]))

        scaleAndOpacity.timingMode = .easeInEaseOut

        node.runAction(scaleAndOpacity)
    }
}
