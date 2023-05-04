//
//  ConnectedGroupsView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct ConnectedGroupsView: View {
    
    @Binding var groups: [Group]
    
    var body: some View {
        List {
            Text("Connected Groups")
                .padding(.bottom)
                .font(.title)
                .fontWeight(.bold)
            
            ForEach($groups) { $group in
                GroupView(group: $group)
            }
        }
        .onChange(of: groups) { newValue in
            print("GROUP UPDATED")
        }
    }
}
