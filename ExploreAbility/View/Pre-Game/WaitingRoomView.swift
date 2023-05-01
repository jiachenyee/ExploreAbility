//
//  WaitingRoomView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import SwiftUI

struct WaitingRoomView: View {
    
    var groupName: String
    
    var body: some View {
        VStack {
            Text("Waiting Room")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .padding(.bottom)
            Text("Waiting for the game to start.")
                .font(.system(size: 16))
        }
        .foregroundColor(.white)
    }
}
