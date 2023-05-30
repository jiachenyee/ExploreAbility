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
    
    @State private var isAdminSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationStack {
                Form {
                    Section("Group Name") {
                        TextField("My Group Name", text: $viewModel.groupName)
                    }
                    
                    if viewModel.headingBetweenInitialAndNext != nil {
                        Section {
                            Button("Next") {
                                viewModel.sendHelloMessage(initialBeacon: currentBeacon + 1, nextBeacon: nextBeacon + 1)
                            }
                        }
                    }
                }
                .navigationTitle("Set Up")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isAdminSheetPresented = true
                        } label: {
                            Image(systemName: viewModel.headingBetweenInitialAndNext != nil ? "person.circle" : "person.crop.circle.badge.exclamationmark")
                        }
                    }
                }
                .sheet(isPresented: $isAdminSheetPresented) {
                    AdminSetUpView(viewModel: viewModel, currentBeacon: $currentBeacon, nextBeacon: $nextBeacon)
                }
            }
        }
    }
}
