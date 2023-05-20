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
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                if isTextShown {
                    Button {
                        tapCounter += 1
                        if tapCounter == 10 {
                            viewModel.gameState = .internalTest
                        }
                    } label: {
                        Image(systemName: "eye.slash")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    
                    Text("Put on your blindfolds")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24))
                }
                
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
                withAnimation {
                    isTextShown = true
                }
            }
        }
        .foregroundColor(.white)
        .onAppear {
            hapticsManager.viewModel = viewModel
            hapticsManager.play()
        }
        .onDisappear {
            hapticsManager.stop()
        }
    }
}
