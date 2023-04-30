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
                .padding([.leading, .bottom], 8)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.roomCaptureData != nil {
                ZStack(alignment: .bottomTrailing) {
                    MapSceneView(viewModel: viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black.opacity(0.1))
                        .cornerRadius(8)
                        .padding([.top, .horizontal], 8)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "map")
                                .foregroundColor(.indigo)
                            Text("Customise Map")
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        HStack {
                            Text("Show Beacons")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $viewModel.mapCustomizations.showBeacons)
                                .toggleStyle(.switch)
                        }
                        
                        HStack {
                            Text("Show Groups")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $viewModel.mapCustomizations.showGroups)
                                .toggleStyle(.switch)
                        }
                        
                        if viewModel.mapCustomizations.focusedGroup != nil {
                            HStack {
                                Text("Follow Focused Group")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Spacer()
                                Toggle("", isOn: $viewModel.mapCustomizations.followingFocusedGroup)
                                    .toggleStyle(.switch)
                            }
                        }
                    }
                    .padding()
                    .frame(width: 256)
                    .background(.white.opacity(0.1))
                    .background(.thickMaterial)
                    .cornerRadius(8)
                    .padding()
                    .padding(.trailing, 8)
                }
            } else {
                Text("Import a room model to render map")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
        }
        .padding()
    }
}
