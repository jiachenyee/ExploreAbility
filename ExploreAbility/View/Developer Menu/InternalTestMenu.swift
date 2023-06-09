//
//  InternalTestMenu.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 27/4/23.
//

import SwiftUI

struct InternalTestMenu: View {
    
    @Binding var stage: GameState
    
    var body: some View {
        NavigationStack {
            List {
                Section("Challenge Tester") {
                    ForEach(GameState.allChallenges, id: \.description) { gameState in
                        Button {
                            stage = gameState
                        } label: {
                            HStack {
                                Image(systemName: gameState.toIcon())
                                    .foregroundColor(gameState.toColor())
                                    .frame(width: 32, alignment: .leading)
                                Text(gameState.description)
                            }
                        }
                    }
                }
                
                Section("Precondition Check") {
                    ForEach(GameState.allChallenges, id: \.description) { gameState in
                        let isReady = gameState.performPreconditionCheck()
                        HStack {
                            Image(systemName: isReady ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isReady ? .green : .red)
                                .frame(width: 32, alignment: .leading)
                            Text(gameState.description)
                        }
                    }
                }
                
                Section("View Tester") {
                    Button("Game Over View") {
                        stage = .gameOver
                    }
                }
            }
            .navigationTitle("Debug Menu")
        }
    }
}
