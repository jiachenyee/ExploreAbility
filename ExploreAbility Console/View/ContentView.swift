//
//  ContentView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        HSplitView {
            ConnectedGroupsView(groups: viewModel.groups)
                .frame(minWidth: 256, maxWidth: 400)
            
            VSplitView {
                MapView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HSplitView {
                    CommandsView(viewModel: viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    LoggerView(loggerViewModel: viewModel.logger)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
