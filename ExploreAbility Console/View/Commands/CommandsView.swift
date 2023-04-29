//
//  CommandView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct CommandsView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Commands")
                .padding(8)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 256, maximum: 300))], spacing: 32) {
                    HostingCommandView(location: $viewModel.location,
                                       isActive: $viewModel.isActive)
                }
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .padding()
    }
}
