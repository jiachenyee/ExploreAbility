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
    @State var challengeState = VoiceOverChallengeState.started
    
    @State var dropControls = false
    @State var showCircle = false
    
    @State var isDropped = false
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black
                
                if challengeState == .started || challengeState == .voEnabled {
                    Text("I can't see anything here. Can someone tell me what these controls do?")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .accessibilityHidden(true)
                }
                
                if dropControls && challengeState != .ended {
                    Text("Turn off VoiceOver.")
                        .foregroundColor(.white)
                }
                
                if showCircle {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 20, height: 20, alignment: .center)
                        .matchedGeometryEffect(id: "VoiceOverChallengeBubble", in: namespace)
                        .offset(y: isDropped ? reader.size.height / 2 - 42 : 0)
                        .transition(.scale)
                }
                
                VStack(spacing: dropControls ? -128 : 128) {
                    Toggle("Turn the toggle on", isOn: $toggleValue)
                    
                    Slider(value: $sliderValue) {
                        Text("Set the slider to 50%")
                    }
                    
                    Button("Done") {
                        if 0.45...0.55 ~= sliderValue && toggleValue {
                            withAnimation {
                                challengeState = .succeeded
                            }
                            
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                withAnimation(.easeIn(duration: 1)) {
                                    dropControls = true
                                }
                            }
                        }
                    }
                }
                .accessibilityHidden(challengeState != .voEnabled)
                .disabled(!isVoiceOverRunning)
                .blur(radius: challengeState == .succeeded ? 0 : 24)
                .foregroundColor(.yellow)
                .offset(y: dropControls ? reader.size.height : 0)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onReceive(publisher) { output in
            isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
            
            if isVoiceOverRunning && challengeState == .started {
                challengeState = .voEnabled
            }
            
            if !isVoiceOverRunning && challengeState == .succeeded {
                withAnimation {
                    challengeState = .ended
                }
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        showCircle = true
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                            isDropped = true
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                            onSucceed?()
                        }
                    }
                }
            }
        }
        .font(.system(size: 17))
    }
    
    enum VoiceOverChallengeState {
        case started
        case voEnabled
        case succeeded
        case ended
    }
}
