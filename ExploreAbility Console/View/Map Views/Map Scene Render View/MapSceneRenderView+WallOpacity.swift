//
//  MapSceneRenderView+WallOpacity.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import SceneKit

extension MapSceneRenderView {
    func updateWallOpacity() {
        guard let pointOfView = pointOfView else { return }
        
        let currentCameraPosition = pointOfView.simdWorldPosition
        
        // Check if the camera position has changed
        if previousCameraPosition != nil && simd_distance(previousCameraPosition!, currentCameraPosition) > 0 {
            updateWallOpacity(pointOfView: pointOfView)
        }
        
        // Update the previous camera position
        previousCameraPosition = currentCameraPosition
    }
    
    fileprivate func updateWallOpacity(pointOfView: SCNNode) {
        let thresholdDistance: Float = 10
        let wallNodes = getWallNodes()
        
        for wallNode in wallNodes {
            
            let distance = simd_distance(pointOfView.simdWorldPosition, wallNode.simdWorldPosition)
            
            if distance < thresholdDistance {
                // Calculate the opacity based on distance (closer walls have lower opacity)
                wallNode.opacity = 0.05
            } else {
                // Reset the opacity of other walls
                wallNode.opacity = 1.0
            }
        }
    }
    
    func getWallNodes() -> [SCNNode] {
        guard let parent = scene?.rootNode.childNode(withName: "Walls_grp",
                                                     recursively: true) else { return [] }
        
        return parent.childNodes
    }
}
