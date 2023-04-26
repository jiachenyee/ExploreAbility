//
//  ClosedCaptionsChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI
import AVKit
import AVFoundation

struct ClosedCaptionsChallenge: View {
    
    @State private var player: AVPlayer = AVQueuePlayer()
    
    private let publisher = NotificationCenter.default.publisher(for: UIAccessibility.closedCaptioningStatusDidChangeNotification)
    
    var namespace: Namespace.ID
    
    var onSucceed: (() -> ())?
    
    @State private var looper: AVPlayerLooper?
    @State private var isClosedCaptionsEnabled = false
    
    var body: some View {
        VideoPlayer(player: player) {
            Spacer()
            
            if isClosedCaptionsEnabled {
                Text("You did it!")
                    .font(.system(size: 24))
                    .padding()
                    .background(.black.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(.bottom)
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            let item = AVPlayerItem(url: Bundle.main.url(forResource: "game",
                                                         withExtension: "mp4")!)
            looper = AVPlayerLooper(player: player as! AVQueuePlayer,
                                    templateItem: item)
            
            player.volume = 0
            player.isMuted = true
            
            player.play()
        }
        .onReceive(publisher) { _ in
            isClosedCaptionsEnabled = UIAccessibility.isClosedCaptioningEnabled
            
            if isClosedCaptionsEnabled {
                player = AVPlayer(url: Bundle.main.url(forResource: "success",
                                                       withExtension: "mp4")!)
            }
        }
    }
}
