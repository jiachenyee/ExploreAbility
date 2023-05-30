//
//  AdminSetUpView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 15/5/23.
//

import SwiftUI

struct AdminSetUpView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var currentBeacon: Int
    @Binding var nextBeacon: Int
    
    @State private var password = ""
    @State private var isAdminOptionsShown = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Password") {
                    SecureField("Type in a password", text: $password)
                        .onSubmit {
                            if password == "admin123" {
                                isAdminOptionsShown = true
                            }
                        }
                }
                
                if isAdminOptionsShown {
                    Section {
                        Picker("Current Beacon", selection: $currentBeacon) {
                            ForEach(0..<7) { index in
                                Text("Beacon \(index + 1)")
                                    .tag(index)
                            }
                        }
                        
//                        Picker("Next Beacon", selection: $nextBeacon) {
//                            ForEach(0..<7) { index in
//                                if currentBeacon != index {
//                                    Text("Beacon \(index + 1)")
//                                        .tag(index)
//                                }
//                            }
//                        }
                    } header: {
                        Text("Configure Beacons")
                    }
//                    Section("Point the device at the next beacon") {
//                        Button("Save Heading: \(viewModel.heading)°") {
//                            viewModel.headingBetweenInitialAndNext = viewModel.heading
//                        }
//                    }
                    
                    Button("Save Heading: \(viewModel.heading)°") {
                        viewModel.headingBetweenInitialAndNext = viewModel.heading
                    }
                }
            }
            .navigationTitle("Admin Set Up")
        }
    }
}
