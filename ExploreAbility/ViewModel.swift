//
//  ViewModel.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var completedChallenges: [GameState] = []
    @Published var gameState = GameState.voiceOver
}
