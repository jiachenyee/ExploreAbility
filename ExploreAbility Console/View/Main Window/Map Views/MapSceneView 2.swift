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
    
    @ObservedObject var viewModel: ViewModel
    
    func makeNSView(context: Context) -> MapSceneRenderView {
        let sceneView = MapSceneRenderView()
        
        sceneView.url = viewModel.roomCaptureData?.usdzURL
        sceneView.showsStatistics = true
        sceneView.mapCustomizations = viewModel.mapCustomizations
        sceneView.beaconPositions = viewModel.beaconPositions
        
        return sceneView
    }
    
    func updateNSView(_ nsView: MapSceneRenderView, context: Context) {
        nsView.url = viewModel.roomCaptureData?.usdzURL
        nsView.mapCustomizations = viewModel.mapCustomizations
        nsView.beaconPositions = viewModel.beaconPositions
        nsView.groups = viewModel.groups
    }
}
