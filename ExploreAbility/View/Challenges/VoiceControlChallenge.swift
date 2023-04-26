//
//  VoiceControlChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 26/4/23.
//

import SwiftUI

struct VoiceControlChallenge: View {
    
    var namespace: Namespace.ID
    
    var onSucceed: (() -> ())?
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(systemName: "hand.raised.slash.fill")
                    Image(systemName: "quote.bubble")
                }
                .font(.system(size: 64))
                .foregroundColor(.red)
                .padding(.bottom)
                
                Text("Follow my orders")
                    .font(.system(size: 17))
            }
            VoiceControlDetector()
        }
    }
}

struct VoiceControlDetector: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: TestVC, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> TestVC {
        TestVC()
    }
    
    func updateUIView(_ uiView: TestVC, context: Context) {
        
    }
}

class TestVC: UIViewController {
    override class func accessibilityActivate() -> Bool {
        print("HELLO")
        return true
    }
}

class DummyView: UIView {
    
    override func accessibilityActivate() -> Bool {
        super.accessibilityActivate()
        print("HELLO")
        if UIAccessibility.isVoiceOverRunning {
            // VoiceOver
        } else if UIAccessibility.isSwitchControlRunning {
            // Switch Control
        } else {
            // Probably used Voice Control or Full Keyboard Access
            print("VOICE CONTROL")
        }
        
        return true
    }
}

