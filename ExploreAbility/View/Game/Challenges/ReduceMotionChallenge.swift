//
//  ReduceMotionChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 26/4/23.
//

import SwiftUI

struct ReduceMotionChallenge: View {
    
    var namespace: Namespace.ID
    
    @State var onSucceedCalled = false
    var onSucceed: (() -> ())?
    
    private let publisher = NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification)
    
    @State private var startRandomMove = false
    
    @State private var isDropped = false
    
    @State private var state = ReduceMotionState.started
    
    @EnvironmentObject var successHapticsManager: SuccessHapticsManager
    
    var body: some View {
        GeometryReader { context in
            ZStack {
                switch state {
                case .started:
                    ForEach(0..<20) { index in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.red)
                            .frame(width: .random(in: context.size.width / 2..<context.size.height / 2), height: .random(in: context.size.width / 2..<context.size.height / 2))
                            .offset(x: .random(in: -context.size.width / 2..<context.size.width / 2) + (startRandomMove ? .random(in: -context.size.width / 2..<context.size.width / 2) : 0),
                                    y: .random(in: -context.size.height / 2..<context.size.height / 2) + (startRandomMove ? .random(in: -context.size.width / 2..<context.size.width / 2) : 0))
                            .opacity(0.5)
                            .matchedGeometryEffect(id: "ReduceMotion\(index)", in: namespace)
                    }
                case .reduceMotionEnabled:
                    VStack {
                        ZStack {
                            ForEach(0..<20) { index in
                                Circle()
                                    .fill(.red)
                                    .frame(width: 20, height: 20)
                                    .matchedGeometryEffect(id: "ReduceMotion\(index)", in: namespace)
                            }
                            
                            Circle()
                                .fill(.red)
                                .frame(width: 20, height: 20)
                                .matchedGeometryEffect(id: GameState.reduceMotion, in: namespace)
                        }
                        
                        Text("You did it!\nNow, turn Reduce Motion off.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .offset(y: state == .reduceMotionEnabled ? -300 : 300)
                    }
                case .reduceMotionDisabled:
                    Circle()
                        .fill(.red)
                        .frame(width: 20, height: 20)
                        .matchedGeometryEffect(id: GameState.reduceMotion, in: namespace)
                        .offset(y: isDropped ? context.size.height / 2 - 42 : 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                startRandomMove.toggle()
            }
        }
        .onReceive(publisher) { _ in
            
            if UIAccessibility.isReduceMotionEnabled && state == .started {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    withAnimation {
                        state = .reduceMotionEnabled
                    }
                }
            } else if !UIAccessibility.isReduceMotionEnabled && state == .reduceMotionEnabled {
                withAnimation {
                    state = .reduceMotionDisabled
                }
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    successHapticsManager.fire()
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                        isDropped = true
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        if !onSucceedCalled {
                            onSucceed?()
                            onSucceedCalled = true
                        } else {
                            print("WHAT")
                        }
                    }
                }
            }
        }
    }
    
    enum ReduceMotionState {
        case started
        case reduceMotionEnabled
        case reduceMotionDisabled
    }
}
