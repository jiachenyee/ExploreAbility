//
//  ExploreAbilityApp.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

@main
struct ExploreAbilityApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
                .statusBarHidden()
                .preferredColorScheme(.light)
        }
    }
}
