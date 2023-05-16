//
//  HapticsManager.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 16/5/23.
//

import Foundation
import CoreHaptics

class HapticsManager: ObservableObject {
    private var engine: CHHapticEngine!
    private var continuousPlayer: CHHapticAdvancedPatternPlayer!
    
    var viewModel: ViewModel!
    
    private var progress: Double {
        viewModel.progress
    }
    
    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            engine.playsHapticsOnly = true
            
            try engine.start()
        } catch {
            print("Failed to start the haptic engine: \(error.localizedDescription)")
        }
    }
    
    func play() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            let buzzCount = Int(floor((self.progress * 20)) + 1)
            
            let buzzDuration = 1.25 / (Double(buzzCount) * 2)
            
            var count = 0
            Timer.scheduledTimer(withTimeInterval: buzzDuration, repeats: true) { timer in
                if count < buzzCount {
                    self.playHaptic(time: buzzDuration, intensity: 1, sharpness: 1)
                } else {
                    timer.invalidate()
                }
                count += 1
            }
        }
    }
    
    private func playHaptic(time: TimeInterval,
                            intensity: Float,
                            sharpness: Float) {
        
        // Create an event (static) parameter to represent the haptic's intensity.
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                        value: intensity)
        
        // Create an event (static) parameter to represent the haptic's sharpness.
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                        value: sharpness)
        
        // Create an event to represent the transient haptic pattern.
        let event = CHHapticEvent(eventType: .hapticTransient,
                                  parameters: [intensityParameter, sharpnessParameter],
                                  relativeTime: 0)
        
        // Create a pattern from the haptic event.
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            
            // Create a player to play the haptic pattern.
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate) // Play now.
        } catch let error {
            print("Error creating a haptic transient pattern: \(error)")
        }
    }
}
