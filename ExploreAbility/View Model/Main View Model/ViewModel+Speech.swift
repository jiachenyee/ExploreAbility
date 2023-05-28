//
//  ViewModel+Speech.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 27/4/23.
//

import Foundation
import AVFoundation
import Speech

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
    
    func getPermission() {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                print("Authorized yeay")
                //            if let recording = self.recording {
                //              //TODO: Kick off the transcription
                //            }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
    }
}

