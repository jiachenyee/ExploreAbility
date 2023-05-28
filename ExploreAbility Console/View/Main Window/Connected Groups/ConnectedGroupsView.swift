//
//  ConnectedGroupsView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct ConnectedGroupsView: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var groups: [Group]
    
    var body: some View {
        List {
            Text("Connected Groups")
                .padding(.bottom)
                .font(.title)
                .fontWeight(.bold)
            
            ForEach($groups) { $group in
                GroupView(viewModel: viewModel, group: $group)
            }
        }
    }
}
