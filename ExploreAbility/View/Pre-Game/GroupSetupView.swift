//
//  GroupSetupView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import SwiftUI

struct GroupSetupView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Group Name") {
                    TextField("My Group Name", text: $viewModel.groupName)
                }
                
                Section {
                    Button("Next") {
                        viewModel.sendHelloMessage()
                    }
                }
            }
            .navigationTitle("Set Up")
        }
    }
}
