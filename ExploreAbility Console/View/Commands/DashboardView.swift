//
//  CommandView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Dashboard")
                .padding(8)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 400), spacing: 16)], spacing: 16) {
                    HostingCommandView(location: $viewModel.location,
                                       isActive: $viewModel.isActive)
                    RoomModelImportCommandView(roomCaptureData: $viewModel.roomCaptureData)
                    SetBeaconLocationsCommandView(roomCaptureData: viewModel.roomCaptureData, beaconPositions: $viewModel.beaconPositions)
                    BeaconOnlineDashboardView(location: viewModel.location)
                    GameStatusDashboardView(isGameActive: $viewModel.isGameActive)
                    GPSHomingDashboardView(roomCaptureData: viewModel.roomCaptureData)
                }
            }
            .frame(minWidth: 200)
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .padding()
    }
}
