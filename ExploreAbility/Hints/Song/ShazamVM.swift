//
//  ShazamVM.swift
//  ShazamTry
//
//  Created by Muhammad Tafani Rabbani on 16/05/23.
//
import SwiftUI
import ShazamKit
import AVKit


class ShazamVM : NSObject,ObservableObject{
    
    
    @Published var shSession = SHSession()
    @Published var audioEngine = AVAudioEngine()
    @Published var errorMsg : String? = nil {
        didSet{
            print(errorMsg)
        }
    }
    @Published var isRecording = false
    @Published var thePrediction : Track = Track()
    
    override init() {
        super.init()
        shSession.delegate = self
    }
    
    
}

extension ShazamVM : SHSessionDelegate{
    func session(_ session: SHSession, didFind match: SHMatch) {
        if let item = match.mediaItems.first{
            print(item.title ?? "" )
            withAnimation {
                //                self.thePrediction = item.title
                DispatchQueue.main.async {
                    self.thePrediction = Track(item: item)
                }
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let err = error?.localizedDescription{
            DispatchQueue.main.async {
                self.errorMsg = err
                self.stopRecording()
            }
            
        }
    }
    
}

extension ShazamVM{
    func listenMusic(){
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { isAllow in
            if isAllow{
                self.recordAudio()
            }else{
                self.errorMsg = "Please allow microphone access"
            }
        }
    }
    
    func recordAudio(){
        
        if audioEngine.isRunning{
            self.stopRecording()
            
            return
        }
        
        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: .zero)
        
        input.removeTap(onBus: .zero)
        input.installTap(onBus: .zero, bufferSize: 1024, format: format) { buffer, time in
            self.shSession.matchStreamingBuffer(buffer, at: time)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
            withAnimation {
                self.isRecording = true
            }
            print("Started")
        }catch{
            self.errorMsg = error.localizedDescription
        }
    }
    
    func stopRecording(){
        audioEngine.stop()
        
        withAnimation {
            self.isRecording = false
            self.thePrediction = Track()
        }
    }
    }
