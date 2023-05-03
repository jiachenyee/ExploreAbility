//
//  GPSHomingMapView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import SwiftUI
import MapKit

struct GPSHomingMapView: View {
    
    private let locationManager = CLLocationManager()
    
    var roomCaptureData: RoomCaptureData
    
    @Binding var originPosition: GPSPosition?
    
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
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if let coordinate = locationManager.location?.coordinate {
                    timer.invalidate()
                    self.region = MKCoordinateRegion(center: coordinate,
                                                     span: MKCoordinateSpan(latitudeDelta: 0.00001, longitudeDelta: 0.00001))
                }
            }
        }
        .frame(minWidth: 512, minHeight: 512)
        .onChange(of: localLocation) { _ in
            update()
        }
        .onChange(of: region?.center.latitude) { _ in
            update()
        }
        .onChange(of: region?.center.longitude) { _ in
            update()
        }
    }
    
    func update() {
        guard let centerPoint = region?.center,
              let localLocation else { return }
        
        print(getLocalOrigin(lat: centerPoint.latitude, long: centerPoint.longitude, point: Position(x: localLocation.x, y: localLocation.y)))
    }
    
    func getLocalOrigin(lat: Double, long: Double, point pointInLocalSystem: Position) -> GPSPosition {
        let scaleFactor = 1.0 // Replace with your scale factor
        
        // Convert latitude and longitude to radians
        let latInRadians = lat * Double.pi / 180.0
        let longInRadians = long * Double.pi / 180.0
        
        // Convert x and y coordinates to meters
        let xInMeters = pointInLocalSystem.x
        let yInMeters = pointInLocalSystem.y
        
        // Calculate distance from origin in meters
        let distanceFromOriginInMeters = sqrt(xInMeters * xInMeters + yInMeters * yInMeters) * scaleFactor
        
        // Calculate bearing from origin to point in radians
        let bearing = atan2(yInMeters, xInMeters)
        
        // Calculate latitude and longitude of the origin
        let R = 6371000.0 // radius of the Earth in meters
        let originLatInRadians = asin(sin(latInRadians) * cos(distanceFromOriginInMeters / R) + cos(latInRadians) * sin(distanceFromOriginInMeters / R) * cos(bearing))
        let originLongInRadians = longInRadians + atan2(sin(bearing) * sin(distanceFromOriginInMeters / R) * cos(latInRadians), cos(distanceFromOriginInMeters / R) - sin(latInRadians) * sin(originLatInRadians))
        
        // Convert back to degrees
        let originLat = originLatInRadians * 180.0 / Double.pi
        let originLong = originLongInRadians * 180.0 / Double.pi
        
        return GPSPosition(latitude: originLat, longitude: originLong)
    }
}
