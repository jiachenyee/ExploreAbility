//
//  GameStatusDashboardView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import SwiftUI

struct GameStatusDashboardView: View {
    
    @Binding var isGameActive: Bool
    
    var body: some View {
        DashboardElement(icon: {
            Image(systemName: "flag.checkered.2.crossed")
                .foregroundColor(isGameActive ? .green : .red)
        }, title: "Game Status") {
            HStack {
                Text("Game Active")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Spacer()
                
                Toggle(isOn: $isGameActive) {
                    EmptyView()
                }
                .toggleStyle(.switch)
            }
            
            Divider()
            
            Text("There will be a 3-second delay before the game starts to ensure all teams start at the same time.")
        }
    }
}
