//
//  ContentView.swift
//  GameOverView
//
//  Created by Jia Chen Yee on 29/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.openWindow) var openWindow
    
    @ObservedObject var viewModel: GameOverViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                FirstWindowView(viewModel: viewModel)
                    .aspectRatio(1920/1080, contentMode: .fit)
                    .clipped()
                    .border(.red)
                SecondWindowView(viewModel: viewModel)
                    .aspectRatio(1920/1080, contentMode: .fit)
                    .clipped()
                    .border(.red)
            }
            
            HStack {
                Button("Launch Windows") {
                    openWindow(id: "lhs")
                    openWindow(id: "rhs")
                }
                Button("Replay last animation") {
                    viewModel.playAnimation()
                }
            }
            
        }
        .padding()
    }
}
