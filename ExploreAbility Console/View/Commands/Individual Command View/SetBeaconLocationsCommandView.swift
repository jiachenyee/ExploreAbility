//
//  SetBeaconLocationsCommandView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import Foundation
import SwiftUI

struct SetBeaconLocationsCommandView: View {
    
    var roomCaptureData: RoomCaptureData?
    
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
                
                if let walls = roomCaptureData?.walls {
                    GeometryReader { reader in
                        let (lowestX, lowestY, highestX, highestY) = getWallsLowestAndHighest(walls: walls)
                        let height = highestY - lowestY
                        let width = highestX - lowestX
                        let multiplier = min(reader.size.height / height, reader.size.width / width)
                        
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
                        
                        Path { path in
                            for wall in walls {
                                guard let bottom = wall.first, let top = wall.last else { break }
                                let offset = (reader.size.width - width * multiplier) / 2
                                print(offset)
                                path.move(to: .init(x: (bottom.x - lowestX) * multiplier + offset,
                                                    y: (bottom.y - lowestY) * multiplier))
                                path.addLine(to: .init(x: (top.x - lowestX) * multiplier + offset,
                                                       y: (top.y - lowestY) * multiplier))
                            }
                        }
                        .stroke(lineWidth: 2)
                    }
                }
            }
        }
    }
    
    func getWallsLowestAndHighest(walls: [[Position]]) -> (Double, Double, Double, Double) {
        var lowestX = Double.infinity
        var lowestY = Double.infinity
        var highestX = -Double.infinity
        var highestY = -Double.infinity
        
        for wall in walls {
            for position in wall {
                lowestX = min(lowestX, position.x)
                lowestY = min(lowestY, position.y)
                highestX = max(highestX, position.x)
                highestY = max(highestY, position.y)
            }
        }
        
        return (lowestX, lowestY, highestX, highestY)
    }
}
