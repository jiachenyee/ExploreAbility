//
//  GPSHomingMapView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import SwiftUI
import MapKit

struct GPSHomingMapView: View {
    
    let locationManager = CLLocationManager()
    
    var roomCaptureData: RoomCaptureData
    
    @State private var region: MKCoordinateRegion?
    @State private var rotationAngle: Double = 0.0
    
    @State private var xOffset: Double = 0.0
    @State private var yOffset: Double = 0.0
    
    @State private var localLocation: CGPoint?
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }
    
    var body: some View {
        HStack {
            if region != nil {
                VStack {
                    VStack {
                        let bindingCenter = Binding {
                            region!.center
                        } set: { center in
                            region?.center = center
                        }

                        HStack {
                            Text("Latitude")
                                .frame(width: 100, alignment: .leading)
                            TextField("Latitude", value: bindingCenter.latitude, format: .number)
                        }
                        HStack {
                            Text("Longitude")
                                .frame(width: 100, alignment: .leading)
                            TextField("Longitude", value: bindingCenter.longitude, format: .number)
                        }
                    }
                    .padding()
                    
                    ZStack {
                        MapPreviewView(region: $region)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Circle()
                            .fill(.blue)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .fill(.white)
                            }
                            .frame(width: 10, height: 10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            let walls = roomCaptureData.walls
            
            VStack {
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
                        
                        SwiftUI.Group {
                            Path { path in
                                for wall in walls {
                                    guard let bottom = wall.first, let top = wall.last else { break }
                                    
                                    path.move(to: .init(x: (bottom.x - lowestX + xOffset) * multiplier + offset,
                                                        y: (bottom.y - lowestY + yOffset) * multiplier))
                                    path.addLine(to: .init(x: (top.x - lowestX + xOffset) * multiplier + offset,
                                                           y: (top.y - lowestY + yOffset) * multiplier))
                                }
                            }
                            .stroke(lineWidth: 2)
                            
                            Rectangle()
                                .opacity(0.00000001)
                                .onTapGesture { location in
                                    localLocation = .init(x: ((location.x - offset) / multiplier) - xOffset + lowestX,
                                                              y: (location.y / multiplier) - yOffset + lowestY)
                                }
                            
                            if let localLocation {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 10, height: 10)
                                    .position(x: (localLocation.x - lowestX + xOffset) * multiplier + offset,
                                              y: (localLocation.y - lowestY + yOffset) * multiplier)
                            }
                        }
                        .rotationEffect(.degrees(rotationAngle))
                        
                    }
                }
                .clipped()
                
                VStack(alignment: .leading) {
                    Text("1. Click on the location where you are.\n2. Rotate the map to point the north towards the top.")
                    
                    HStack {
                        Image(systemName: "arrow.left.and.right")
                        Stepper("", value: $xOffset, step: 0.01)
                        Spacer()
                        Image(systemName: "arrow.up.and.down")
                        Stepper("", value: $yOffset, step: 0.01)
                    }
                    HStack {
                        Image(systemName: "angle")
                        Slider(value: $rotationAngle, in: 0...360)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            locationManager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.00001, longitudeDelta: 0.00001))
            }
        }
        .frame(minWidth: 512, minHeight: 512)
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

