//
//  MapView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct MapView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Map")
                .padding(8)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.roomCaptureData != nil {
                MapSceneView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Import a room model to render map")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
        }
        .padding()
    }
}
