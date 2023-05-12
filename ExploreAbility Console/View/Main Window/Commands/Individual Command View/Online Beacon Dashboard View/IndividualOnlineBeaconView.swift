//
//  IndividualOnlineBeaconView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct IndividualOnlineBeaconView: View {
    
    var beaconIndex: Int
    var lastUpdateDate: Date?
    
    var status: BeaconStatus
    
    @State private var isHovering = false
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a"
        return dateFormatter
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(status.toColor())
                .frame(width: 50, height: 50)
            if isHovering {
                if let lastUpdateDate {
                    Text(lastUpdateDate, style: .timer)
                        .font(.system(size: 16))
                } else {
                    Text("💀")
                        .font(.system(size: 24))
                }
            } else {
                Text("\(beaconIndex)")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .onHover { isHovering in
            self.isHovering = isHovering
        }
    }
}
