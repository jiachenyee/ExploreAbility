//
//  ContentView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace var namespace
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        switch viewModel.gameState {
        case .exploring:
            ExploringView(viewModel: viewModel, namespace: namespace)
        case .textSize:
            TextSizeChallenge(namespace: namespace) {
                withAnimation(.easeOut) {
                    viewModel.gameState = .exploring
                    viewModel.completedChallenges.append(.textSize)
                }
            }
        case .voiceOver:
            VoiceOverChallenge(namespace: namespace) {
                withAnimation(.easeOut) {
                    viewModel.gameState = .exploring
                    viewModel.completedChallenges.append(.voiceOver)
                }
            }
        case .closedCaptions:
            EmptyView()
        case .voiceControl:
            EmptyView()
        case .guidedAccess:
            EmptyView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
