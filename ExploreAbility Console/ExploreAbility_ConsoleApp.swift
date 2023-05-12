//
//  ExploreAbility_ConsoleApp.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

@main
struct ExploreAbility_ConsoleApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        .windowStyle(.hiddenTitleBar)
        
        Window("Nothing to see here.", id: "nothing-to-see-here") {
            PrivateControllerView()
        }
    }
}
