//
//  SceneView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 30/4/23.
//

import Foundation
import SceneKit

class MapSceneRenderView: SCNView {
    var url: URL? {
        didSet {
            guard url != oldValue,
                  let url,
                  let scene = try? SCNScene(url: url) else { return }
            
            setUpScene(scene: scene)
        }
    }
    
    var mapCustomizations: MapCustomisations! {
        didSet {
            guard mapCustomizations != oldValue else { return }
            
            updateMapCustomization(oldValue)
        }
    }
    
    var beaconPositions: [Position?]! {
        didSet {
            guard beaconPositions != oldValue,
                  let beaconPositions else { return }
            
            SCNTransaction.begin()
            for (n, beaconPosition) in beaconPositions.enumerated() {
                if let beaconPosition {
                    beaconGroupNode.childNodes[n].position = SCNVector3(x: beaconPosition.x, y: 1, z: beaconPosition.y)
                    beaconGroupNode.childNodes[n].isHidden = false
                } else {
                    beaconGroupNode.childNodes[n].isHidden = true
                }
            }
            SCNTransaction.commit()
        }
    }
    
    // MARK: - Nodes
    let beaconGroupNode = SCNNode()
    let groupsGroupNode = SCNNode()
    let gridNode = SCNNode()
    
    var previousCameraPosition: simd_float3?
    
    init() {
        super.init(frame: .zero)
        
        setUpSceneView()
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
    
    func createGroupNode() {
        let geometry = SCNSphere(radius: 0.25)
        
        geometry.firstMaterial?.diffuse.contents = NSColor.systemBlue.withAlphaComponent(0.5)
        
        let node = SCNNode(geometry: geometry)
        
        node.position = .init(0, 1, 0)
        
        let action = SCNAction.repeatForever(
            .sequence([
                .moveBy(x: 0, y: 0.2, z: 0, duration: 1),
                .moveBy(x: 0, y: -0.2, z: 0, duration: 1)
            ])
        )
        
        action.timingMode = .easeInEaseOut
        
        node.runAction(action)
        
        scene?.rootNode.addChildNode(node)
    }
}
