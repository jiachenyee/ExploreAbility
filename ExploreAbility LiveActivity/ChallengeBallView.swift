//
//  ChallengeBallView.swift
//  ExploreAbility LiveActivityExtension
//
//  Created by Jia Chen Yee on 4/5/23.
//

import SwiftUI

struct ChallengeBallView: View {
    
    var challenges: [GameState]
    var index: Int
    
    var body: some View {
        Group {
            if index > challenges.count - 1 {
                EmptyView()
            } else {
                Circle()
                    .fill(challenges[index].toColor())
                    .frame(width: 8, height: 8)
            }
        }
    }
}
