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
        // Create an AVSpeechSynthesizer instance
        let synthesizer = AVSpeechSynthesizer()
        
        // Create an AVSpeechUtterance with the given text
        let utterance = AVSpeechUtterance(string: text)
        
        // Set the voice to use for the utterance (optional)
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.voice = voice
        
        // Speak the utterance using the synthesizer
        synthesizer.speak(utterance)
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

