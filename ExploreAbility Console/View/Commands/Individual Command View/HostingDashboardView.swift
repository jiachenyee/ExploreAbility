//
//  HostingDashboardView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct HostingDashboardView: View {
    
    @Binding var location: Location
    @Binding var isActive: Bool
    
    var body: some View {
        DashboardElement(icon: {
            Image(systemName: "antenna.radiowaves.left.and.right" + (isActive ? "" : ".slash"))
                .foregroundColor(isActive ? .green : .red)
        }, title: "Hosting") {
            Text("Location")
                .font(.title3)
                .fontWeight(.medium)
            
            Picker(selection: $location) {
                Text("Academy Lab")
                    .tag(Location.academy)
                Text("Foundation Lab")
                    .tag(Location.foundation)
            } label: {
                EmptyView()
            }
            
            Divider()
                .padding(.vertical, 4)
            
            HStack {
                Text("Online")
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                Toggle("", isOn: $isActive)
                    .toggleStyle(.switch)
            }
        }
    }
}
