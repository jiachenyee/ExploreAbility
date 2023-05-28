//
//  SecondWindowView.swift
//  GameOverView
//
//  Created by Jia Chen Yee on 29/5/23.
//

import SwiftUI

struct SecondWindowView: View {
    
    @Namespace var namespace
    
    @ObservedObject var viewModel: GameOverViewModel
    
    var body: some View {
        ZStack {
            Color.black
            GeometryReader { reader in
                switch viewModel.currentState {
                case .leaderboards:
                    if viewModel.arrivedGroups.count > 0 {
                        VStack {
                            Spacer()
                            HStack {
                                VStack {
                                    ForEach(0..<6) { rank in
                                        let rankValue = rank
                                        
                                        if viewModel.arrivedGroups.count > rankValue {
                                            HStack {
                                                Circle()
                                                    .fill(.white.opacity(0.2))
                                                    .matchedGeometryEffect(id: viewModel.arrivedGroups[rankValue].id, in: namespace)
                                                    .frame(width: reader.size.width / 30, height: reader.size.width / 30)
                                                    .overlay {
                                                        Text("\(rank + 1)")
                                                            .font(.system(size: reader.size.width / 40, weight: .regular))
                                                    }
                                                Text(viewModel.arrivedGroups[rankValue].name)
                                            }
                                            .font(.system(size: reader.size.width / 30, weight: .bold))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack {
                                    ForEach(0..<6) { rank in
                                        let rankValue = rank + 6
                                        
                                        if viewModel.arrivedGroups.count > rankValue {
                                            HStack {
                                                Circle()
                                                    .matchedGeometryEffect(id: viewModel.arrivedGroups[rankValue].id, in: namespace)
                                                    .foregroundColor(.white.opacity(0.2))
                                                    .frame(width: reader.size.width / 30, height: reader.size.width / 30)
                                                    .overlay {
                                                        Text("\(rankValue + 1)")
                                                            .font(.system(size: reader.size.width / 40, weight: .regular))
                                                    }
                                                Text(viewModel.arrivedGroups[rankValue].name)
                                            }
                                            .font(.system(size: reader.size.width / 30, weight: .bold))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                            }
                            Spacer()
                        }
                        .padding(.leading, reader.size.width / 20)
                    } else {
                        VStack {
                            Spacer()
                            Text("No one has won yet!")
                                .font(.system(size: reader.size.width / 20, weight: .bold))
                            Spacer()
                        }
                        .padding(.leading, reader.size.width / 20)
                    }
                case .successAnimation:
                    let maxWidth = reader.size.width * 2
                    
                    Circle()
                        .fill(.green)
                        .matchedGeometryEffect(id: viewModel.arrivedGroups.last?.id ?? "", in: namespace)
                        .overlay {
                            if viewModel.isCircleRankShown {
                                VStack {
                                    Text("\(viewModel.arrivedGroups.count)")
                                        .font(.system(size: reader.size.width / 5, weight: .bold, design: .rounded))
                                    Text(viewModel.arrivedGroups.last?.name ?? "")
                                        .font(.system(size: reader.size.width / 20, weight: .medium, design: .rounded))
                                }
                            }
                        }
                        .frame(width: maxWidth * viewModel.circleScale, height: maxWidth * viewModel.circleScale)
                        .offset(x: maxWidth / 2 - (maxWidth * viewModel.circleScale) / 2 - reader.size.width, y: reader.size.height -
                                (reader.size.width * viewModel.circleScale))
                        .offset(y: reader.size.height * viewModel.circleOffset)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
