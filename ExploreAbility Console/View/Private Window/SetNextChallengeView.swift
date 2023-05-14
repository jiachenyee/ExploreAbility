//
//  SetNextChallengeView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 5/5/23.
//

import Foundation
import SwiftUI

struct SetNextChallengeView: View {
    
    var roomCaptureData: RoomCaptureData
    
    var beaconPositions: [Position?]
    
    var body: some View {
        let walls = roomCaptureData.walls
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
                
                ForEach(Array(beaconPositions.enumerated()), id: \.offset) { (index, beacon) in
                    if let beacon = beacon {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .overlay {
                                    Text("\(index + 1)")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 50, height: 50)
                                .position(x: (beacon.x - lowestX) * multiplier + offset,
                                          y: (beacon.y - lowestY) * multiplier)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.1))
        .clipped()
    }
}
