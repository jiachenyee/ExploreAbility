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
        
        let radioWaveBubble = SCNSphere(radius: 0.25)
        
        radioWaveBubble.firstMaterial?.diffuse.contents = NSColor.systemBlue.withAlphaComponent(0.5)
        
        let radioWaveBubbleNode = SCNNode(geometry: radioWaveBubble)
        
        createBeaconAnimation(radioWaveBubbleNode)
        
        beaconNode.addChildNode(radioWaveBubbleNode)
        
        beaconNode.isHidden = true
        
        return beaconNode
    }
    
    fileprivate func createBeaconAnimation(_ node: SCNNode) {
        let scaleAndOpacity = SCNAction.repeatForever(
            .sequence([
                .group([
                    .scale(to: 10, duration: 2),
                    .fadeOpacity(to: 0, duration: 2)]),
                .group([.fadeOpacity(to: 1, duration: 0), .scale(to: 1, duration: 0)])
            ]))
        
        scaleAndOpacity.timingMode = .linear
        
        node.runAction(scaleAndOpacity)
    }
}
