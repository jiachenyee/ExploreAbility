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
                .foregroundColor(.white)
            
            Text("No Connection")
                .multilineTextAlignment(.center)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Rectangle()
                .fill(.gray)
                .frame(height: 0.5)
            
            HStack {
                Text("Location")
                Spacer()
                Picker(selection: $viewModel.location) {
                    Text("Academy Lab")
                        .tag(Location.academy)
                    Text("Foundation Lab")
                        .tag(Location.foundation)
                } label: {
                    Text("Location")
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            
            Rectangle()
                .fill(.gray)
                .frame(height: 0.5)
            
            HStack {
                Toggle(isOn: $isBrowserPresented) {
                    Label("Select ExploreAbility Console", systemImage: "server.rack")
                }
                .toggleStyle(.button)
                Spacer()
            }
            .padding(.horizontal, 4)
            
            Rectangle()
                .fill(.gray)
                .frame(height: 0.5)
            
            Spacer()
            
            Text("Make sure the ExploreAbility Console is set up and ready.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16))
                .padding(.horizontal)
                .foregroundColor(.white)
        }
        .sheet(isPresented: $isBrowserPresented) {
            MCBrowserView(session: viewModel.mcSession)
        }
    }
}
