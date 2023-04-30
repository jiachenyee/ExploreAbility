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
            
//            addSampleNode()
            createBeaconNode()
            let x = createGridPlane()
            scene.rootNode.addChildNode(x)
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
        
        geometry.firstMaterial?.diffuse.contents = NSColor.systemBlue.withAlphaComponent(0.5)
        
        let node = SCNNode(geometry: geometry)
        
        node.position = .init(0, 1, 0)
        
//        let bounceAnimation = CABasicAnimation(keyPath: "position.y")
//        bounceAnimation.fromValue = 1
//        bounceAnimation.toValue = 1.2
//        bounceAnimation.duration = 1
//        bounceAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        bounceAnimation.autoreverses = true
//        bounceAnimation.repeatCount = .infinity
        
//        node.addAnimation(bounceAnimation, forKey: "bounce")
        
        let scale = SCNAction.scale(to: 5, duration: 2)
        let opacity = SCNAction.fadeOpacity(to: 0, duration: 2)
        
        let scaleAndOpacity = SCNAction.repeatForever(
            .sequence([
                .group([scale, opacity]),
                .group([.fadeOpacity(to: 1, duration: 0), .scale(to: 1, duration: 0)])
            ]))
        
        scaleAndOpacity.timingMode = .easeIn
        
        node.runAction(scaleAndOpacity)
        scene?.rootNode.addChildNode(node)
    }
    
    func createBeaconNode() {
        let beacon = SCNSphere(radius: 0.25)
        beacon.firstMaterial?.diffuse.contents = NSColor.systemBlue
        
        let beaconNode = SCNNode(geometry: beacon)
        beaconNode.position = .init(0, 1, 0)
        
        let radioWaveBubble = SCNSphere(radius: 0.25)
        
        radioWaveBubble.firstMaterial?.diffuse.contents = NSColor.systemBlue.withAlphaComponent(0.5)
        
        let radioWaveBubbleNode = SCNNode(geometry: radioWaveBubble)
        
        
        let scaleAndOpacity = SCNAction.repeatForever(
            .sequence([
                .group([
                    .scale(to: 10, duration: 2),
                    .fadeOpacity(to: 0, duration: 2)]),
                .group([.fadeOpacity(to: 1, duration: 0), .scale(to: 1, duration: 0)])
            ]))
        
        scaleAndOpacity.timingMode = .linear
        
        radioWaveBubbleNode.runAction(scaleAndOpacity)
        
        beaconNode.addChildNode(radioWaveBubbleNode)
        
        scene?.rootNode.addChildNode(beaconNode)
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
    
    func createGridPlane() -> SCNNode {
        let size = 50.0
        // Create a plane
        let planeGeometry = SCNPlane(width: CGFloat(size), height: CGFloat(size))
        let planeNode = SCNNode(geometry: planeGeometry)
        
        // Create a grid material
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = NSColor(white: 0.5, alpha: 0.25) // Adjust the color and opacity as needed
        
        // Apply the grid material to the plane
        planeGeometry.firstMaterial?.diffuse.contents = NSColor.clear
        gridMaterial.lightingModel = .constant
        // Add grid lines to the plane
        
        let gridSize = 50
        for i in -(gridSize / 2)...(gridSize / 2) {
            // Horizontal lines
            let horizontalLine = SCNNode(geometry: SCNPlane(width: CGFloat(size), height: 0.1))
            horizontalLine.geometry?.materials = [gridMaterial]
            horizontalLine.position = SCNVector3(0, Float(i), 0)
            planeNode.addChildNode(horizontalLine)
            
            // Vertical lines
            let verticalLine = SCNNode(geometry: SCNPlane(width: 0.1, height: CGFloat(size)))
            verticalLine.geometry?.materials = [gridMaterial]
            verticalLine.position = SCNVector3(Float(i), 0, 0)
            planeNode.addChildNode(verticalLine)
        }
        
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.position = .init(x: 0, y: -1.5, z: 0)
        
        return planeNode
    }

}
