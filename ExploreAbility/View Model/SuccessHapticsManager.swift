//
//  SuccessHapticsManager.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 28/5/23.
//

import Foundation
import CoreHaptics
import AVFAudio

class SuccessHapticsManager: ObservableObject {
    private var engine: CHHapticEngine!
    private var continuousPlayer: CHHapticAdvancedPatternPlayer!
    
    init() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            engine = try CHHapticEngine(audioSession: audioSession)
        } catch let error {
            print("Engine Creation Error: \(error)")
        }
    }
    
    func startHapticEngine() {
        try? engine?.start()
    }
    
    func fire() {
        guard let path = Bundle.main.path(forResource: "success", ofType: "ahap") else {
            return
        }
        
        try? engine?.playPattern(from: URL(fileURLWithPath: path))
    }
}
