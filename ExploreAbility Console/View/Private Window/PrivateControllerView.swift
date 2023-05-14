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
                SetNextChallengeView(roomCaptureData: roomCaptureData, beaconPositions: viewModel.beaconPositions)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
