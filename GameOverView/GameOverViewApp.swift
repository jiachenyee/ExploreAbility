//
//  GameOverViewApp.swift
//  GameOverView
//
//  Created by Jia Chen Yee on 29/5/23.
//

import SwiftUI
import FirebaseCore

@main
struct GameOverViewApp: App {
    
    @StateObject var viewModel = GameOverViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        
        Window("LHS", id: "lhs") {
            FirstWindowView(viewModel: viewModel)
        }
        
        Window("RHS", id: "rhs") {
            SecondWindowView(viewModel: viewModel)
        }
    }
}
