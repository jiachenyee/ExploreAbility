//
//  TransmittingView.swift
//  ExploreAbility Beacon
//
//  Created by Jia Chen Yee on 26/4/23.
//

import SwiftUI

struct TransmittingView: View {
    
    @Binding var isActive: Bool
    
    @State private var isAlertPresented = false
    @State private var imageState = 0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            Image("radiowave.00\(imageState + 1)")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                
            Text("Transmitting iBeacon")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            Spacer()
            Button("Disable Beacon", role: .destructive) {
                isAlertPresented.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .alert("Are you sure you want to disable this beacon?", isPresented: $isAlertPresented) {
            Button("Disable Beacon", role: .destructive) {
                isActive = false
            }
            
            Button("Cancel", role: .cancel) {
                
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                imageState += 1
                imageState %= 3
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
