//
//  SceneView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 30/4/23.
//

import Foundation
import SceneKit

class MapSceneRenderView: SCNView, SCNSceneRendererDelegate {
    var url: URL? {
        didSet {
            guard url != oldValue,
                  let url,
                  let scene = try? SCNScene(url: url) else { return }
            
            scene.background.contents = NSColor.clear
            
            self.scene = scene
            
            for wallNode in getWallNodes() {
                guard let material = wallNode.geometry?.firstMaterial else { continue }
                material.isDoubleSided = true
                material.transparencyMode = .dualLayer
            }
            
            addSampleNode()
        }
    }
    
    init() {
        super.init(frame: .zero)
        allowsCameraControl = true
        autoenablesDefaultLighting = true
        backgroundColor = .clear
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    override init(frame: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options   )
    }
    
    func addSampleNode() {
        let geometry = SCNSphere(radius: 0.25)
        
        geometry.firstMaterial?.diffuse.contents = NSColor.white
        
        let node = SCNNode(geometry: geometry)
        
        node.position = .init(0, 1, 0)
        
        let bounceAnimation = CABasicAnimation(keyPath: "position.y")
        bounceAnimation.fromValue = 1
        bounceAnimation.toValue = 1.2
        bounceAnimation.duration = 1
        bounceAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        bounceAnimation.autoreverses = true
        bounceAnimation.repeatCount = .infinity
        
        node.addAnimation(bounceAnimation, forKey: "bounce")
        
        scene?.rootNode.addChildNode(node)
    }
    
    var previousCameraPosition: simd_float3?

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let pointOfView = pointOfView else { return }
        
        let currentCameraPosition = pointOfView.simdWorldPosition
        
        // Check if the camera position has changed
        if previousCameraPosition != nil && simd_distance(previousCameraPosition!, currentCameraPosition) > 0 {
            updateWallOpacity(pointOfView: pointOfView)
        }
        
        // Update the previous camera position
        previousCameraPosition = currentCameraPosition
    }
    
    func updateWallOpacity(pointOfView: SCNNode) {
        let thresholdDistance: Float = 5
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
        guard let parent = scene?.rootNode.childNode(withName: "Walls_grp", recursively: true) else { return [] }
        
        return parent.childNodes
    }
}
