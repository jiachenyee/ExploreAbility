//
//  MapSceneView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation
import SwiftUI
import SceneKit

struct MapSceneView: NSViewRepresentable {
    
    private let sceneView = SCNView()
    
    @ObservedObject var viewModel: ViewModel
    
    func makeNSView(context: Context) -> SCNView {
        if let usdzURL = viewModel.roomCaptureData?.usdzURL,
           let scene = try? SCNScene(url: usdzURL) {
            
            sceneView.scene = scene
        }
        
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .clear
        
        return sceneView
    }
    
    func updateNSView(_ nsView: SCNView, context: Context) {
        if let usdzURL = viewModel.roomCaptureData?.usdzURL,
           let scene = try? SCNScene(url: usdzURL) {
            scene.background.contents = NSColor.clear
            sceneView.scene = scene
        }
    }
}
