//
//  BeaconOnlineDashboardView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct BeaconOnlineDashboardView: View {
    
    @EnvironmentObject var logger: Logger
    
    @StateObject var beaconStatusViewModel = BeaconStatusViewModel()
    
    var location: Location
    
    var body: some View {
        DashboardElement(icon: {
            Image(systemName: "sensor.tag.radiowaves.forward")
                .foregroundColor(.cyan)
        }, title: "Beacon Pings") {
            VStack(spacing: 4) {
                
                if location == .academy {
                    HStack {
                        IndividualOnlineBeaconView(beaconIndex: 1, lastUpdateDate: beaconStatusViewModel.academyBeacons[0],
                                                   status: beaconStatusViewModel.academyStatus[0])
                        IndividualOnlineBeaconView(beaconIndex: 2, lastUpdateDate: beaconStatusViewModel.academyBeacons[1],
                                                   status: beaconStatusViewModel.academyStatus[1])
                    }
                    HStack {
                        IndividualOnlineBeaconView(beaconIndex: 3, lastUpdateDate: beaconStatusViewModel.academyBeacons[2],
                                                   status: beaconStatusViewModel.academyStatus[2])
                        IndividualOnlineBeaconView(beaconIndex: 4, lastUpdateDate: beaconStatusViewModel.academyBeacons[3],
                                                   status: beaconStatusViewModel.academyStatus[3])
                        IndividualOnlineBeaconView(beaconIndex: 5, lastUpdateDate: beaconStatusViewModel.academyBeacons[4],
                                                   status: beaconStatusViewModel.academyStatus[4])
                    }
                    HStack {
                        IndividualOnlineBeaconView(beaconIndex: 6, lastUpdateDate: beaconStatusViewModel.academyBeacons[5],
                                                   status: beaconStatusViewModel.academyStatus[5])
                        IndividualOnlineBeaconView(beaconIndex: 7, lastUpdateDate: beaconStatusViewModel.academyBeacons[6],
                                                   status: beaconStatusViewModel.academyStatus[6])
                    }
                } else {
                    HStack {
                        IndividualOnlineBeaconView(beaconIndex: 1, lastUpdateDate: beaconStatusViewModel.foundationBeacons[0],
                                                   status: beaconStatusViewModel.foundationStatus[0])
                        IndividualOnlineBeaconView(beaconIndex: 2, lastUpdateDate: beaconStatusViewModel.foundationBeacons[1],
                                                   status: beaconStatusViewModel.foundationStatus[1])
                        IndividualOnlineBeaconView(beaconIndex: 3, lastUpdateDate: beaconStatusViewModel.foundationBeacons[2],
                                                   status: beaconStatusViewModel.foundationStatus[2])
                    }
                    HStack {
                        IndividualOnlineBeaconView(beaconIndex: 4, lastUpdateDate: beaconStatusViewModel.foundationBeacons[3],
                                                   status: beaconStatusViewModel.foundationStatus[3])
                        IndividualOnlineBeaconView(beaconIndex: 5, lastUpdateDate: beaconStatusViewModel.foundationBeacons[4],
                                                   status: beaconStatusViewModel.foundationStatus[4])
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
