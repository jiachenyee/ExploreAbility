//
//  SetBeaconLocationsView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 30/4/23.
//

import SwiftUI

struct SetBeaconLocationsView: View {
    
    @State var scale: CGFloat = 1.0
    @State var newScale = 1.0
    
    @State var rotation = Angle.zero
    @State var newRotation = Angle.zero
    
    var roomCaptureData: RoomCaptureData?
    @Binding var beaconPositions: [Position?]
    
    var body: some View {
        VStack {
            if let walls = roomCaptureData?.walls {
                GeometryReader { reader in
                    let (lowestX, lowestY, highestX, highestY) = getWallsLowestAndHighest(walls: walls)
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
                                print(offset)
                                path.move(to: .init(x: (bottom.x - lowestX) * multiplier + offset,
                                                    y: (bottom.y - lowestY) * multiplier))
                                path.addLine(to: .init(x: (top.x - lowestX) * multiplier + offset,
                                                       y: (top.y - lowestY) * multiplier))
                            }
                        }
                        .stroke(lineWidth: 2)
                        
                        ForEach(0..<5) { (i: Int) in
                            if let location = beaconPositions[i] {
                                ZStack {
                                    Circle()
                                        .fill(.blue)
                                    Text(String(i + 1))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 0.25 * multiplier, height: 0.25 * multiplier)
                                .position(x: (location.x - lowestX) * multiplier + offset, y: (location.y - lowestY) * multiplier)
                            }
                        }
                        
                        Rectangle()
                            .fill(.clear)
                            .onDrop(of: [.plainText], delegate: BeaconDropDelegate { value, location in
                                Task {
                                    await MainActor.run {
                                        beaconPositions[value] = .init(x: (location.x - offset) / multiplier + lowestX,
                                                                       y: location.y / multiplier + lowestY)
                                    }
                                }
                            })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.1))
                .clipped()
            }
            
            Divider()
                .padding(.bottom, 8)
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { index in
                        ZStack {
                            Circle()
                                .fill(.blue.opacity(beaconPositions[index] == nil ? 0.1 : 1))
                                .frame(width: 64, height: 64)
                            Text("\(index + 1)")
                                .font(.system(size: 32))
                        }
                        .draggable("\(index)") {
                            Image(systemName: "xmark")
                                .foregroundColor(.blue)
                        }
                    }
                    Spacer()
                }
                .padding([.bottom, .horizontal])
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
    
    struct BeaconDropDelegate: DropDelegate {
        
        var onDrop: ((Int, CGPoint) -> ())?
        
        func performDrop(info: DropInfo) -> Bool {
            guard let itemProvider = info.itemProviders(for: [.plainText]).first else { return false }
            
            _ = itemProvider.loadTransferable(type: String.self) { result in
                switch result {
                case .success(let string):
                    guard let value = Int(string) else { return }
                    
                    Task {
                        await onDrop?(value, info.location)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
            return true
        }
    }
}

