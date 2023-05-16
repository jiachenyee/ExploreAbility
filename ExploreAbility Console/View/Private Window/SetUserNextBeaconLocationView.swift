//
//  SetUserNextBeaconLocationView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 15/5/23.
//

import SwiftUI

struct SetUserNextBeaconLocationView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var request: NextChallenge
    
    @State private var beaconIndex = 0
    
    var body: some View {
        let groupIndex = viewModel.groups.firstIndex(where: {
            $0.id == request.groupId
        })!
        
        let group = viewModel.groups[groupIndex]
        
        Form {
            TextField("Current Beacon", text: .constant(group.currentBeacon.description))
                .textFieldStyle(.plain)
                .disabled(true)
            
            Picker("Next Beacon", selection: $beaconIndex) {
                ForEach(0..<7) { index in
                    if group.currentBeacon == index + 1 {
                        Text("Beacon \(index + 1)")
                            .tag(index)
                    }
                }
            }
            
            Button("Done") {
                viewModel.sendNextChallengeMessage(nextChallenge: request.challenge,
                                                   beacon: beaconIndex,
                                                   to: &viewModel.groups[groupIndex])
            }
        }
        .padding()
    }
}
