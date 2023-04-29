//
//  BeaconOnlineDashboardView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct BeaconOnlineDashboardView: View {
    var body: some View {
        DashboardElement(icon: {
            Image(systemName: "sensor.tag.radiowaves.forward")
                .foregroundColor(.cyan)
        }, title: "Beacon Pings") {
            
        }
    }
}

struct BeaconOnlineDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconOnlineDashboardView()
    }
}
