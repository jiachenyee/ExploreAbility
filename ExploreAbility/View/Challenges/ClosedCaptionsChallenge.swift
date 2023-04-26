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
    
    private let player = AVQueuePlayer()
    
    private let publisher = NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)
    
    var namespace: Namespace.ID
    
    var onSucceed: (() -> ())?
    
    @State private var looper: AVPlayerLooper?
    
    var body: some View {
        VideoPlayer(player: player) {
            Spacer()
            Text("You did it!")
                .font(.system(size: 24))
                .padding()
                .background(.black.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(16)
            Spacer()
        }
        .allowsHitTesting(false)
        .onAppear {
            let item = AVPlayerItem(url: Bundle.main.url(forResource: "video-sample", withExtension: "mp4")!)
            looper = AVPlayerLooper(player: player,
                                    templateItem: item)
            
            player.play()
            
            player.volume = 0
            player.isMuted = true
        }
    }
}
