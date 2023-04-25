//
//  VoiceOverChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct VoiceOverChallenge: View {
    
    private let publisher = NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)
    
    var namespace: Namespace.ID
    
    var onSucceed: (() -> ())?
    
    @State var sliderValue = 0.0
    @State var toggleValue = false
    
    @State var isVoiceOverRunning = false
    @State var didSucceed = false
    
    var body: some View {
        ZStack {
            Color.black
            
            if !didSucceed {
                Text("I can't see anything here. Can someone tell me what these controls do?")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .accessibilityHidden(true)
            }
            
            VStack(spacing: 128) {
                Toggle("Turn the toggle on", isOn: $toggleValue)
                
                Slider(value: $sliderValue) {
                    Text("Set the slider to 50%")
                }
                
                Button("Done") {
                    if 0.45...0.55 ~= sliderValue && toggleValue {
                        
                        withAnimation {
                            didSucceed = true
                        }
                    }
                }
            }
            .disabled(!isVoiceOverRunning)
            .blur(radius: didSucceed ? 0 : 48)
            
        }
        .edgesIgnoringSafeArea(.all)
        .onReceive(publisher) { output in
            isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
        }
    }
}
