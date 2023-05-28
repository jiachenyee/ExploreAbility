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
    
    @EnvironmentObject var successHapticsManager: SuccessHapticsManager
    
    @State private var looper: AVPlayerLooper?
    @State private var isClosedCaptionsEnabled = false
    @State private var isYouDidItShown = false
    
    @State private var convertToCircle = false
    @State private var isDropped = false
    
    @State private var hideVideoPlayer = false
    
    var body: some View {
        ZStack {
            GeometryReader { context in
                if !convertToCircle {
                    let circleRadius = context.size.height * 1.5
                    
                    Circle()
                        .fill(.green)
                        .frame(width: circleRadius, height: circleRadius)
                        .matchedGeometryEffect(id: GameState.closedCaptions, in: namespace)
                        .offset(x: -(circleRadius - context.size.width) / 2, y: -(circleRadius - context.size.height) / 2)
                    
                    if !hideVideoPlayer {
                        VideoPlayer(player: player)
                            .allowsHitTesting(false)
                            .scaleEffect((1080 / context.size.width) / (1920 / context.size.height))
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            GeometryReader { context in
                ZStack {
                    VStack {
                        Spacer()
                        
                        if isYouDidItShown {
                            Text("You did it!")
                                .font(.system(size: 24))
                                .padding()
                                .background(.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .padding(.bottom, 64)
                        }
                    }
                    
                    if convertToCircle {
                        Circle()
                            .fill(.green)
                            .frame(width: 20, height: 20)
                            .matchedGeometryEffect(id: GameState.closedCaptions, in: namespace)
                            .offset(y: isDropped ? context.size.height / 2 - 42 : 0)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            let item = AVPlayerItem(url: Bundle.main.url(forResource: "game",
                                                         withExtension: "mov")!)
            looper = AVPlayerLooper(player: player as! AVQueuePlayer,
                                    templateItem: item)
            
            player.volume = 0
            player.isMuted = true
            player.audiovisualBackgroundPlaybackPolicy = .continuesIfPossible
            player.play()
        }
        .onReceive(publisher) { _ in
            isClosedCaptionsEnabled = UIAccessibility.isClosedCaptioningEnabled
            
            if isClosedCaptionsEnabled {
                isYouDidItShown = true
                looper?.disableLooping()
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    player.replaceCurrentItem(with: AVPlayerItem(url: Bundle.main.url(forResource: "success",
                                                                                      withExtension: "mov")!))
                    player.play()
                    
                    Timer.scheduledTimer(withTimeInterval: 5.25, repeats: false) { _ in
                        player.pause()
                        
                        withAnimation {
                            isYouDidItShown = false
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            hideVideoPlayer = true
                            withAnimation {
                                convertToCircle = true
                            }
                            
                            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                                
                                successHapticsManager.fire()
                                
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                                    isDropped = true
                                }
                                
                                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                                    onSucceed?()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
