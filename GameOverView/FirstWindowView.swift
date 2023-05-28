//
//  FirstWindowView.swift
//  GameOverView
//
//  Created by Jia Chen Yee on 29/5/23.
//

import SwiftUI

struct FirstWindowView: View {
    
    @ObservedObject var viewModel: GameOverViewModel
    
    var body: some View {
        ZStack {
            Color.black
            GeometryReader { reader in
                switch viewModel.currentState {
                case .leaderboards:
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text("ExploreAbility")
                            .font(.system(size: reader.size.width / 15, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                        Text("Leaderboards")
                            .font(.system(size: reader.size.width / 12, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\nOnce you’ve completed the game,\nplace your device down on the table.")
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: reader.size.width / 30, weight: .regular))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, reader.size.width / 20)
                case .successAnimation:
                    let maxWidth = reader.size.width * 2
                    
                    Circle()
                        .fill(.green)
                        .overlay {
                            if viewModel.isCircleRankShown {
                                VStack {
                                    Text("\(viewModel.arrivedGroups.count)")
                                        .font(.system(size: reader.size.width / 5, weight: .bold, design: .rounded))
                                    Text(viewModel.arrivedGroups.last?.name ?? "")
                                        .font(.system(size: reader.size.width / 20, weight: .medium, design: .rounded))
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .frame(width: maxWidth * viewModel.circleScale, height: maxWidth * viewModel.circleScale)
                        .offset(x: maxWidth / 2 - (maxWidth * viewModel.circleScale) / 2,
                                y: reader.size.height -
                                (reader.size.width * viewModel.circleScale))
                        .offset(y: reader.size.height * viewModel.circleOffset)
                }
                
                Text("APPLE DEVELOPER ACADEMY @ INFINITE LEARNING BATAM")
                    .font(.system(size: reader.size.width / 200, weight: .regular))
                    .foregroundColor(.white.opacity(0.35))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(reader.size.width / 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
