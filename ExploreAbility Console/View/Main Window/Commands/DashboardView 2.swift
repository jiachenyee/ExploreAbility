//
//  CommandView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var setUpExpanded = true
    @State private var gameControlsExpanded = true
    @State private var monitoringExpanded = true
    
    var body: some View {
        VStack {
            Text("Dashboard")
                .padding(8)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                DisclosureGroup(isExpanded: $setUpExpanded) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 400), spacing: 16)], spacing: 16) {
                        RoomModelImportDashboardView(roomCaptureData: $viewModel.roomCaptureData)
                        SetBeaconsDashboardView(roomCaptureData: viewModel.roomCaptureData, beaconPositions: $viewModel.beaconPositions)
                        GPSHomingDashboardView(roomCaptureData: viewModel.roomCaptureData, originPosition: $viewModel.originPosition)
                        NothingToSeeHereDashboardView()
                    }
                    .padding(.top, 8)
                } label: {
                    HStack {
                        Image(systemName: "checklist")
                        Text("Set Up")
                    }
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        withAnimation {
                            setUpExpanded.toggle()
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                DisclosureGroup(isExpanded: $gameControlsExpanded) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 400), spacing: 16)], spacing: 16) {
                        HostingDashboardView(location: $viewModel.location,
                                             isActive: $viewModel.isActive)
                        GameStatusDashboardView(isGameActive: $viewModel.isGameActive)
                    }
                    .padding(.top, 8)
                } label: {
                    HStack {
                        Image(systemName: "flag.checkered")
                        Text("Game Controls")
                    }
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        withAnimation {
                            gameControlsExpanded.toggle()
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                DisclosureGroup(isExpanded: $monitoringExpanded) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 400), spacing: 16)], spacing: 16) {
                        BeaconOnlineDashboardView(location: viewModel.location)
                    }
                    .padding(.top, 8)
                } label: {
                    HStack {
                        Image(systemName: "speedometer")
                        Text("Monitoring")
                    }
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        withAnimation {
                            monitoringExpanded.toggle()
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
            }
            .frame(minWidth: 200)
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .padding()
    }
}
