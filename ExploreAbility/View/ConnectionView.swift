//
//  ConnectionView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI
import MultipeerConnectivity

struct ConnectionView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State var isBrowserPresented = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 32))
            
            Text("No Connection")
                .multilineTextAlignment(.center)
                .font(.system(size: 24))
                .fontWeight(.bold)
            
            Toggle(isOn: $isBrowserPresented) {
                Label("Select ExploreAbility Console", systemImage: "server.rack")
            }
                .toggleStyle(.button)
            
            Spacer()
            
            Text("Make sure the ExploreAbility Console is set up and ready.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16))
                .padding(.horizontal)
        }
        .sheet(isPresented: $isBrowserPresented) {
            MCBrowserView(session: viewModel.mcSession)
        }
    }
}
