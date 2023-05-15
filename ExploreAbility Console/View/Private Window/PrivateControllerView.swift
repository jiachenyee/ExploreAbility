//
//  PrivateControllerView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 12/5/23.
//

import SwiftUI

struct PrivateControllerView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HSplitView {
            VStack {
                if viewModel.nextChallengeRequests.isEmpty {
                    Text("Nothing to see here.")
                    Text("Make sure this view is kept out of view of the players.")
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.nextChallengeRequests) { nextChallengeRequest in
                                if let group = viewModel.groups.first(where: {
                                    $0.id == nextChallengeRequest.groupId
                                }) {
                                    VStack {
                                        Text("\(group.name) requested for the next challenge.")
                                        Button("Assign") {
                                            
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if let roomCaptureData = viewModel.roomCaptureData {
                ScrollView {
                    VStack(spacing: 0) {
                        SetNextChallengeView(roomCaptureData: roomCaptureData, beaconPositions: viewModel.beaconPositions)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .aspectRatio(1, contentMode: .fit)
                        Divider()
                        Text("Beacons")
                            .padding()
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(0..<7) { beaconIndex in
                            VStack(alignment: .leading) {
                                
                                Text("Beacon \(beaconIndex)")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                
                                let (arrivals, at, departures) = getGroups(at: beaconIndex)
                                
                                HStack(alignment: .top) {
                                    VStack {
                                        Label("Arrivals", systemImage: "figure.walk.arrival")
                                            .fontWeight(.bold)
                                        ForEach(arrivals, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Divider()
                                    VStack {
                                        Label("At", systemImage: "figure.stand")
                                            .fontWeight(.bold)
                                        ForEach(at, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                    VStack {
                                        Label("Departures", systemImage: "figure.walk.departure")
                                            .fontWeight(.bold)
                                        ForEach(departures, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Divider()
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(minWidth: 200)
            }
        }
    }
    
    func getGroups(at beaconIndex: Int) -> ([String], [String], [String]) {
        var arrivals: [String] = []
        var at: [String] = []
        var departures: [String] = []
        
        for group in viewModel.groups {
            if group.currentBeacon == beaconIndex + 1 && (group.progress ?? 0.5) < 0.3 {
                if group.currentState == .exploring {
                    arrivals.append(group.name)
                } else {
                    arrivals.append(group.name)
                }
            } else if group.nextChallengeBeacon == beaconIndex + 1 {
                departures.append(group.name)
            }
        }
        
        return (arrivals, at, departures)
    }
}
