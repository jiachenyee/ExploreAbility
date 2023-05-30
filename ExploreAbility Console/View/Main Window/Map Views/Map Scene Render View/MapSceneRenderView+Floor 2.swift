//
//  MapSceneRenderView+Floor.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import SceneKit

extension MapSceneRenderView {
    func createFloor() {
        guard let scene else { return }
        
        let geometry = SCNBox(width: scene.rootNode.boundingBox.max.x - scene.rootNode.boundingBox.min.x,
                              height: 0.25,
                              length: scene.rootNode.boundingBox.max.z - scene.rootNode.boundingBox.min.z,
                              chamferRadius: 0.1)
        
        geometry.materials.first?.diffuse.contents = NSColor.white
        
        let node = SCNNode(geometry: geometry)
        
        node.position = .init(x: (scene.rootNode.boundingBox.min.x + scene.rootNode.boundingBox.max.x) / 2,
                              y: (scene.rootNode.boundingBox.min.y) - 0.25,
                              z: (scene.rootNode.boundingBox.min.z + scene.rootNode.boundingBox.max.z) / 2)
        
        gridNode.addChildNode(node)
    }
}
