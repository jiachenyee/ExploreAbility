//
//  ViewModel+Speech.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 27/4/23.
//

import Foundation
import AVFoundation

extension ViewModel {
    func say(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        
        let voice = AVSpeechSynthesisVoice(language: "en-GB")!
        
        utterance.voice = voice
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        synthesizer.speak(utterance)
        print(synthesizer.isSpeaking)
    }
}

