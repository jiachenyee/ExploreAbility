//
//  NothingToSeeHereDashboardView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 5/5/23.
//

import Foundation
import SwiftUI

struct NothingToSeeHereDashboardView: View {
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        DashboardElement(icon: {
            Image(systemName: "eyes.inverse")
                .foregroundColor(.orange)
        }, title: "Private Controller") {
            Text("While a game is ongoing, certain features might need to be hidden from players.\n\nPut this window on a screen that will not be visible on AirPlay.")
            Button("Show Window") {
                openWindow(id: "nothing-to-see-here")
            }
        }
    }
}
