//
//  DeveloperMenuConfirmationView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 28/4/23.
//

import SwiftUI

struct DeveloperMenuConfirmationView: View {
    
    @State private var openMenu = false
    @State private var offset = 0.0
    
    @Binding var gameState: GameState
    
    var body: some View {
        if openMenu {
            InternalTestMenu(stage: $gameState)
        } else {
            GeometryReader { reader in
                ZStack {
                    LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.1)
                    
                    Text("Enter Debug Menu")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                
                ZStack {
                    LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 56, height: 56)
                        .cornerRadius(8)
                    
                    Image(systemName: "chevron.right")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { dragValue in
                            offset = dragValue.translation.width
                        }
                        .onEnded { dragValue in
                            if dragValue.translation.width > reader.size.width / 2 {
                                withAnimation {
                                    openMenu = true
                                }
                            } else {
                                withAnimation(.spring()) {
                                    offset = 0
                                }
                            }
                        }
                )
            }
            .background(.white)
            .frame(height: 56)
            .cornerRadius(8)
            .padding()
        }
    }
}
