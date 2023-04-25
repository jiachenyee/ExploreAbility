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
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            switch viewModel.gameState {
            case .connection:
                ConnectionView(viewModel: viewModel)
            case .exploring:
                ExploringView(viewModel: viewModel, namespace: namespace)
            case .textSize:
                TextSizeChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
                        viewModel.gameState = .exploring
                        viewModel.completedChallenges.append(.textSize)
                    }
                }
            case .voiceOver:
                VoiceOverChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
