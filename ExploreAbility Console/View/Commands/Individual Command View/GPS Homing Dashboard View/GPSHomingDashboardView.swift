//
//  GPSHomingDashboardView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import SwiftUI
import MapKit

struct GPSHomingDashboardView: View {
    
    var roomCaptureData: RoomCaptureData?
    @Binding var originPosition: GPSPosition?
    
    @State private var setUpPresented = false
    
    var body: some View {
        DashboardElement(icon: {
            Image(systemName: "location")
        }, title: "GPS Homing") {
            Text("Set the current location of this Mac compared against the local map scan.")
            
            Divider()
            
            if let roomCaptureData {
                Button("Set Up") {
                    setUpPresented = true
                }
                .sheet(isPresented: $setUpPresented) {
                    GPSHomingMapView(roomCaptureData: roomCaptureData, originPosition: $originPosition)
                }
            } else {
                Text("Import a room model to set up.")
            }
        }
    }
}
