//
//  GameOverView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 11/5/23.
//

import SwiftUI

let password = Int.random(in: 100000...999999)

struct GameOverView: View {
    
    var groupName: String
    
    @State var isPasswordViewVisible = false
    
    @State var isPasswordVisible = false
    
    @StateObject private var goViewModel = GameOverViewModel()
    
    var body: some View {
        switch goViewModel.state {
        case .ar:
            ZStack {
                
                GameOverARView(isPasswordVisible: $isPasswordVisible)
                    .edgesIgnoringSafeArea(.all)
                
                Image("coral.001")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.2)
                
                Text("Find this anywhere within the academy")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .font(.system(size: 16))
                    .padding()
                
                if isPasswordVisible {
                    Text(String(password))
                        .foregroundColor(.white)
                        .font(.system(size: 32, design: .monospaced))
                        .padding()
                        .background(.black)
                        .cornerRadius(8)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
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
            .onAppear {
                goViewModel.groupName = groupName
            }
        case .unlocked, .scanning:
            GameOverUnlockedView {
                goViewModel.state = .scanning
            }
        case .completed:
            GeometryReader { context in
                Rectangle()
                    .fill(.green)
                    .frame(width: context.size.width * goViewModel.animationPercentage)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
