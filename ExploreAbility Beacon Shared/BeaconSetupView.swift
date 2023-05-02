//
//  ContentView.swift
//  ExploreAbility Beacon
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct BeaconSetupView: View {
    
    @StateObject var beaconManager = BeaconManager()
    
    @State var currentLocation = Location.academy
    @State var beaconIndex = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(selection: $currentLocation) {
                        Text("Academy Lab")
                            .tag(Location.academy)
                        Text("Foundation Lab")
                            .tag(Location.foundation)
                    } label: {
                        Text("Location")
                    }
                    
                    Picker(selection: $beaconIndex) {
                        ForEach(0..<7) { index in
                            Text("\(index + 1)")
                        }
                    } label: {
                        Text("Beacon Index")
                    }
                }
                
                Button {
                    beaconManager.setUp(region: currentLocation == .academy ? .allAcademyBeacons[beaconIndex + 1] : .allFoundationBeacons[beaconIndex + 1])
                } label: {
                    Text("Initialize Beacon")
                }
            }
            .navigationTitle("Setup Beacon")
            .modifier(PopupModifier(isPresented: $beaconManager.isActive))
        }
    }
}

struct BeaconSetupView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconSetupView()
    }
}
