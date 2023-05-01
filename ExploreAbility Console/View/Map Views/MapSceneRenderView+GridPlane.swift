//
//  MapSceneRenderView+GridPlane.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import SceneKit

extension MapSceneRenderView {
    func createGridPlane() {
        let size = 50
        
        let planeGeometry = SCNPlane(width: CGFloat(size), height: CGFloat(size))
        let planeNode = SCNNode(geometry: planeGeometry)
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = NSColor(white: 0.5, alpha: 0.25) // Adjust the color and opacity as needed
        
        planeGeometry.firstMaterial?.diffuse.contents = NSColor.clear
        gridMaterial.lightingModel = .constant
        
        for i in -(size / 2)...(size / 2) {
            let horizontalLine = SCNNode(geometry: SCNPlane(width: CGFloat(size), height: 0.1))
            horizontalLine.geometry?.materials = [gridMaterial]
            horizontalLine.position = SCNVector3(0, Float(i), 0)
            planeNode.addChildNode(horizontalLine)
            
            let verticalLine = SCNNode(geometry: SCNPlane(width: 0.1, height: CGFloat(size)))
            verticalLine.geometry?.materials = [gridMaterial]
            verticalLine.position = SCNVector3(Float(i), 0, 0)
            planeNode.addChildNode(verticalLine)
        }
        
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.position = .init(x: 0, y: -1.5, z: 0)
        
        gridNode.addChildNode(planeNode)
    }
}
