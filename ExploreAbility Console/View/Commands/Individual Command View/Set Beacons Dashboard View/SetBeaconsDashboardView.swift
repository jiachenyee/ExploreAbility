//
//  SetBeaconsDashboardView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation
import SwiftUI

struct SetBeaconsDashboardView: View {
    
    var roomCaptureData: RoomCaptureData?
    @Binding var beaconPositions: [Position?]
    
    @State var isSetUpSheetPresented = false
    
    var body: some View {
        DashboardElement(icon: {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(.blue)
        }, title: "Configure Beacons") {
            VStack(alignment: .leading) {
                if let walls = roomCaptureData?.walls {
                    HStack {
                        Text("Set Beacon Locations")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            isSetUpSheetPresented = true
                        } label: {
                            Text("Set Up")
                        }
                    }
                    .sheet(isPresented: $isSetUpSheetPresented) {
                        SetBeaconsView(roomCaptureData: roomCaptureData,
                                               beaconPositions: $beaconPositions)
                            .frame(minWidth: 512, maxWidth: .infinity, minHeight: 512, maxHeight: .infinity)
                    }
                    
                    GeometryReader { reader in
                        let (lowestX, lowestY, highestX, highestY) = walls.getLowestAndHighest()
                        let height = highestY - lowestY
                        let width = highestX - lowestX
                        let multiplier = min(reader.size.height / height, reader.size.width / width)
                        
                        if reader.size.width > 0 && reader.size.height > 0 {
                            let rows = Int(reader.size.height / multiplier)
                            let columns = Int(reader.size.width / multiplier)
                            
                            Path { path in
                                // Draw vertical grid lines
                                for column in 0...columns {
                                    let x = CGFloat(column) * multiplier
                                    path.move(to: CGPoint(x: x, y: 0))
                                    path.addLine(to: CGPoint(x: x, y: reader.size.height))
                                }
                                
                                // Draw horizontal grid lines
                                for row in 0...rows {
                                    let y = CGFloat(row) * multiplier
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: reader.size.width, y: y))
                                }
                            }
                            .stroke(lineWidth: 1)
                            .foregroundColor(.blue)
                            .opacity(0.5)
                            .border(.blue)
                            
                            let offset = (reader.size.width - width * multiplier) / 2
                            
                            Path { path in
                                for wall in walls {
                                    guard let bottom = wall.first, let top = wall.last else { break }
                                    
                                    path.move(to: .init(x: (bottom.x - lowestX) * multiplier + offset,
                                                        y: (bottom.y - lowestY) * multiplier))
                                    path.addLine(to: .init(x: (top.x - lowestX) * multiplier + offset,
                                                           y: (top.y - lowestY) * multiplier))
                                }
                            }
                            .stroke(lineWidth: 2)
                            
                            ForEach(0..<7) { (i: Int) in
                                if let location = beaconPositions[i] {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 0.25 * multiplier, height: 0.25 * multiplier)
                                        .position(x: (location.x - lowestX) * multiplier + offset, y: (location.y - lowestY) * multiplier)
                                }
                            }
                        }
                    }
                } else {
                    Text("Import a Room Scan to configure beacons.")
                }
            }
        }
    }
}
