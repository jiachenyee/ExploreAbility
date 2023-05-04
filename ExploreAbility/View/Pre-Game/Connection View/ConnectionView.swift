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
    @State var tapCounter = 0
    
    @State private var location: Location = .academy
    
    @State var isSearching = false
    
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
            
            Text(viewModel.deviceId)
            
            Rectangle()
                .fill(.gray)
                .frame(height: 0.5)
            
            if !isSearching {
                Picker("Location", selection: $location) {
                    Text("Academy Lab")
                        .tag(Location.academy)
                    Text("Foundation Lab")
                        .tag(Location.foundation)
                }
                .padding(.horizontal, 4)
                
                Rectangle()
                    .fill(.gray)
                    .frame(height: 0.5)
                
                Button("Start Session") {
                    viewModel.startSearching(for: location)
                    
                    withAnimation {
                        isSearching = true
                    }
                }
            } else {
                Group {
                    Text("Connecting…")
                        .foregroundColor(.white)
                    ProgressView()
                        .tint(.white)
                }
                .padding(.vertical)
            }
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
    }
}
