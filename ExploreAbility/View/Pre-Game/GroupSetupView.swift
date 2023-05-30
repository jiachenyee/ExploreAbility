//
//  GroupSetupView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import SwiftUI

struct GroupSetupView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var currentBeacon = 0
    @State private var nextBeacon = 1
    @State private var location: Location = .academy
    
    @State private var isAdminSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationStack {
                Form {
                    Section("Group Name") {
                        TextField("My Group Name", text: $viewModel.groupName)
                    }
                    
                    Section {
                        Picker("Current Beacon", selection: $currentBeacon) {
                            ForEach(1..<7) { index in
                                Text("Beacon \(index)")
                                    .tag(index)
                            }
                        }
                        
                        Picker("Location", selection: $viewModel.location) {
                            Text("Academy Lab")
                                .tag(Location.academy)
                            Text("Foundation Lab")
                                .tag(Location.foundation)
                        }
                        
                    } header: {
                        Text("Configure Beacons")
                    }
                    
                    if currentBeacon >= 0{
                        Section {
                            Button("Next") {
//                                viewModel.sendHelloMessage(initialBeacon: currentBeacon + 1, nextBeacon: nextBeacon + 1)
                                viewModel.nextChallenge = .init(challenge: .exploring, beacon: currentBeacon)
                                
                                withAnimation {
                                    viewModel.gameState = .exploring
                                }
                            }
                        }
                    }
                   
                }
                .navigationTitle("Set Up")
            }
        }
    }
}
