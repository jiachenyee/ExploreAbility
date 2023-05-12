//
//  GameOverView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 11/5/23.
//

import SwiftUI

struct GameOverView: View {
    
    @State var isPasswordViewVisible = false
    
    @StateObject private var goViewModel = GameOverViewModel()
    
    var body: some View {
        switch goViewModel.state {
        case .ar:
            ZStack {
                GameOverARView()
                    .edgesIgnoringSafeArea(.all)
                
                Button {
                    withAnimation {
                        isPasswordViewVisible.toggle()
                    }
                } label: {
                    Image(systemName: "entry.lever.keypad")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

                if isPasswordViewVisible {
                    PasswordView(isVisible: $isPasswordViewVisible) {
                        withAnimation {
                            goViewModel.state = .unlocked
                        }
                    }
                }
            }
        case .unlocked, .scanning:
            GameOverUnlockedView()
        case .completed:
            EmptyView()
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
