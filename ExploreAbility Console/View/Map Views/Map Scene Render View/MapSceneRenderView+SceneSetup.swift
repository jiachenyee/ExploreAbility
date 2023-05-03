//
//  MapSceneRenderView+SceneSetup.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import SceneKit

extension MapSceneRenderView: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateWallOpacity()
    }
    
    func setUpScene(scene: SCNScene) {
        self.scene = scene
        
        scene.background.contents = NSColor.clear
        
        for wallNode in getWallNodes() {
            guard let material = wallNode.geometry?.firstMaterial else { continue }
            material.isDoubleSided = true
            material.transparencyMode = .dualLayer
        }
        scene.rootNode.castsShadow = true
        scene.rootNode.addChildNode(gridNode)
        scene.rootNode.addChildNode(beaconGroupNode)
        createFloor()
    }
    
    func setUpSceneView() {
        allowsCameraControl = true
        backgroundColor = .clear
        
        delegate = self
        
        setUpBeaconNodes()
    }
}
