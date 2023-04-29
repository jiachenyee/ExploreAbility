//
//  SetBeaconLocationsCommandView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation
import SwiftUI

struct SetBeaconLocationsCommandView: View {
    
    var body: some View {
        CommandView(icon: {
            Image(systemName: "sensor.tag.radiowaves.forward")
                .foregroundColor(.blue)
        }, title: "Configure Beacons") {
            VStack(alignment: .leading) {
                HStack {
                    Text("Set Beacon Locations")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Set Up")
                    }
                }
            }
        }
    }
}
