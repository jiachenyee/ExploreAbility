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
            case .internalTest:
                InternalTestMenu(stage: $viewModel.gameState)
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
                ClosedCaptionsChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
                        viewModel.gameState = .exploring
                        viewModel.completedChallenges.append(.closedCaptions)
                    }
                }
            case .reducedMotion:
                ReducedMotionChallenge(namespace: namespace) {
                    viewModel.gameState = .exploring
                    viewModel.completedChallenges.append(.reducedMotion)
                }
            case .guidedAccess:
                GuidedAccessChallenge(namespace: namespace,viewModel: viewModel) {
                    viewModel.gameState = .exploring
                    viewModel.completedChallenges.append(.guidedAccess)
                }
            }
            if viewModel.gameState.hints != nil{
                VStack {
                    
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                viewModel.hintsModel.hintShow.toggle()
                            }
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 35,height: 35 )
                        }

                    }
                    Spacer()
                    
                }.padding()
            }
            
        }
        .sheet(isPresented: $viewModel.hintsModel.hintShow) {
            HintsView(viewModel: viewModel)
                
                .presentationDetents(Set(viewModel.hintsModel.listDetent.map { $0 }),selection: $viewModel.hintsModel.selectedDetent)
                
                
        }
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
