//
//  GameOverARView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 10/5/23.
//

import Foundation
import UIKit
import SwiftUI
import ARKit

struct GameOverARView: UIViewRepresentable {
    
    @Binding var isPasswordVisible: Bool
    
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView()
        
        // Set up with captured object anchor
        let configuration = ARWorldTrackingConfiguration()
        let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Resource Group", bundle: .main)
        configuration.detectionObjects = referenceObjects!
        
        view.delegate = context.coordinator
        
        view.session.run(configuration)
        
        return view
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    static func dismantleUIView(_ uiView: ARSCNView, coordinator: Coordinator) {
        uiView.session.pause()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        
        var parent: GameOverARView
        
        init(_ parent: GameOverARView) {
            self.parent = parent
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if anchor.name == "Coral" {
                let cubeNode = createCubeNode()
                
                node.addChildNode(cubeNode)
                node.rotation = .init(0, 0, 0, 0)
                
                withAnimation(.default.delay(5.5)) {
                    self.parent.isPasswordVisible = true
                }
                print("HELLO")
            }
            
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if anchor.name == "Coral" {
                node.rotation = .init(0, 0, 0, 0)
            }
        }
        
        var player: AVPlayer!
        
        func createCubeNode() -> SCNNode {
            let cube = SCNPyramid(width: 0.5, height: 1, length: 0.5)
            
            cube.materials = []
            
            player = AVPlayer(url: Bundle.main.url(forResource: "gameover", withExtension: "mov")!)
            player.play()
            
            let colors: [AVPlayer] = [player, player, player, player, player, player]
            
            // rotate cube
            
            for i in 0..<5 {
                let material = SCNMaterial()
                material.diffuse.contents = colors[i] //.withAlphaComponent(0.5)
//                material.blendMode = .multiply
                
                // flip material vertically
                material.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                
                cube.materials.append(material)
            }
            
            let cubeNode = SCNNode(geometry: cube)
            
            cubeNode.eulerAngles = .init(x: 0, y: 0, z: .pi)
            cubeNode.position = SCNVector3(0, 1, 0)
            
            // make node spin forever
            let spin = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 10)
            let repeatSpin = SCNAction.repeatForever(spin)
            
            // run action
            cubeNode.runAction(repeatSpin)
            
            return cubeNode
        }
        
        func createVideoNode() -> SCNNode {
            let videoURL = Bundle.main.url(forResource: "success", withExtension: "mov")!
            let player = AVPlayer(url: videoURL)
            let videoNode = SKVideoNode(avPlayer: player)
            videoNode.play()
            
            let spriteKitScene = SKScene(size: CGSize(width: 480, height: 360))
            spriteKitScene.addChild(videoNode)
            
            videoNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
            videoNode.size = spriteKitScene.size
            
            let tvPlane = SCNPlane(width: 1.0, height: 0.75)
            tvPlane.firstMaterial?.diffuse.contents = spriteKitScene
            tvPlane.firstMaterial?.isDoubleSided = true
            
            let tvPlaneNode = SCNNode(geometry: tvPlane)
            tvPlaneNode.eulerAngles.x = -.pi / 2
            tvPlaneNode.position = SCNVector3(0, 0.5, 0)
            
            return tvPlaneNode
        }
    }
}
