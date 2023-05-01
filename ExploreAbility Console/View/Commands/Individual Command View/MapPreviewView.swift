//
//  MapPreviewView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 2/5/23.
//

import Foundation
import MapKit
import SwiftUI

struct MapPreviewView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    @Binding var region: MKCoordinateRegion?
    
    func makeNSView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        
        view.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
        view.showsZoomControls = true
        view.delegate = context.coordinator
        view.cameraZoomRange = .init(minCenterCoordinateDistance: .leastNormalMagnitude, maxCenterCoordinateDistance: .greatestFiniteMagnitude)
        view.showsCompass = true
        
        return view
    }
    
    func updateNSView(_ nsView: MKMapView, context: Context) {
        if let region {
            nsView.setRegion(region, animated: true)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapPreviewView!
        
        init(_ parent: MapPreviewView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = mapView.region
        }
    }
}
