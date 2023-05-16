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
    
    let groupColors: [NSColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemMint, .systemPurple, .systemPink]
    
    var groups: [Group] = [] {
        didSet {
            guard groups != oldValue,
                  !groups.isEmpty else { return }
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            for (n, group) in groups.enumerated() {
                if !oldValue.contains(where: { $0.id == group.id }) {
                    createGroupNode(index: n)
                }
                
                guard let node = groupsGroupNode.childNode(withName: "\(n)", recursively: false) else { return }
                
                if let progress = group.progress,
                   let initialPosition = beaconPositions[group.currentBeacon],
                   let nextPosition = beaconPositions[group.nextChallengeBeacon] {
                    
                    let position = initialPosition.getMidpointPosition(with: nextPosition, progress: progress)
                    
                    node.position = .init(x: position.x, y: scene!.rootNode.boundingBox.min.y + 2, z: position.y)
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
        super.init(frame: frame, options: options)
    }
    
    func createGroupNode(index: Int) {
        let geometry = SCNSphere(radius: 0.4)
        
        geometry.firstMaterial?.diffuse.contents = groupColors[index % groupColors.count]
        geometry.firstMaterial?.emission.contents = groupColors[index % groupColors.count]
        
        let node = SCNNode(geometry: geometry)
        
        node.position = .init(0, scene!.rootNode.boundingBox.min.y + 2, 0)
        
        let light = SCNLight()
        light.type = .omni
        
        light.areaType = .polygon
        light.color = groupColors[index % groupColors.count].withAlphaComponent(0.8)
        light.intensity = 5
        
        node.light = light
        
        let action = SCNAction.repeatForever(
            .sequence([
                .moveBy(x: 0, y: 0.5, z: 0, duration: 1),
                .moveBy(x: 0, y: -0.5, z: 0, duration: 1)
            ])
        )
        
        action.timingMode = .easeInEaseOut
        
        node.runAction(action)
        
        node.name = "\(index)"
        
        groupsGroupNode.addChildNode(node)
    }
}
