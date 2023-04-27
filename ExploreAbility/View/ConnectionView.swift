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
    @State var tapCounter = 0
    
    var body: some View {
        VStack {
            if !GameState.all.allSatisfy({ $0.performPreconditionCheck() }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 32))
                    VStack(alignment: .leading) {
                        Text("Failed Precondition Check")
                            .bold()
                        Text("Check debug menu and restart app")
                    }
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(.gray.opacity(0.5)).cornerRadius(8)
                .padding()
            }
            
            
            Spacer()
            
            Group {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .onTapGesture {
                        tapCounter += 1
                        if tapCounter == 10 {
                            viewModel.gameState = .internalTest
                        }
                    }
                
                Text("No Connection")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
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
