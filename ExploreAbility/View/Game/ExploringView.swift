//
//  ExploringView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct ExploringView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var namespace: Namespace.ID
    
    @State var isTextShown = false
    @State var tapCounter = 0
    
    @StateObject var hapticsManager = HapticsManager()
    
    @State var isCompassVisible = false
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                
                Button {
                    tapCounter += 1
                    if tapCounter == 10 {
                        viewModel.gameState = .internalTest
                    }
                } label: {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
                
                Text("Find the next check point to based on the haptics")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24))
                
                
                Spacer()
                
                HStack {
                    ForEach(viewModel.completedChallenges, id: \.rawValue) { challenge in
                        ZStack {
                            Circle()
                                .fill(challenge.toColor())
                                .frame(width: 30, height: 30)
                                .matchedGeometryEffect(id: challenge, in: namespace)
                            Image(systemName: challenge.toIcon())
                                .font(.system(size: 17))
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .onAppear {
                hapticsManager.viewModel = viewModel
                hapticsManager.play()
                
                if let nextChallenge = viewModel.nextChallenge?.challenge.next,
                   let checkpoint = viewModel.availableCheckpoints.randomElement() {
                    
                    viewModel.availableCheckpoints.removeAll {
                        $0 == viewModel.nextChallenge?.beacon
                    }
                    
                    viewModel.nextChallenge = .init(challenge: nextChallenge, beacon: checkpoint)
                    
                    viewModel.availableCheckpoints.removeAll {
                        $0 == checkpoint
                    }
                    
                    print("NEXT IS", checkpoint)
                } else {
                    // Game over
                }
            }
            .onDisappear {
                hapticsManager.stop()
            }
        }
        .foregroundColor(.white)
    }
    
    
}
