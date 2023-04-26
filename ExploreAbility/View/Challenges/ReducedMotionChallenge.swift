//
//  ReducedMotionChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 26/4/23.
//

import SwiftUI

struct ReducedMotionChallenge: View {
    
    var namespace: Namespace.ID
    
    @State var onSucceedCalled = false
    var onSucceed: (() -> ())?
    
    private let publisher = NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification)
    
    @State private var startRandomMove = false
    
    @State private var isDropped = false
    
    @State private var state = ReducedMotionState.started
    
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
                            .matchedGeometryEffect(id: "ReducedMotion\(index)", in: namespace)
                    }
                case .reducedMotionEnabled:
                    VStack {
                        ZStack {
                            ForEach(0..<20) { index in
                                Circle()
                                    .fill(.red)
                                    .frame(width: 20, height: 20)
                                    .matchedGeometryEffect(id: "ReducedMotion\(index)", in: namespace)
                            }
                            
                            Circle()
                                .fill(.red)
                                .frame(width: 20, height: 20)
                                .matchedGeometryEffect(id: GameState.reducedMotion, in: namespace)
                        }
                        
                        Text("You did it!\nNow, turn Reduced Motion off.")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .offset(y: state == .reducedMotionEnabled ? -300 : 300)
                    }
                case .reducedMotionDisabled:
                    Circle()
                        .fill(.red)
                        .frame(width: 20, height: 20)
                        .matchedGeometryEffect(id: GameState.reducedMotion, in: namespace)
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
                        state = .reducedMotionEnabled
                    }
                }
            } else if !UIAccessibility.isReduceMotionEnabled && state == .reducedMotionEnabled {
                withAnimation {
                    state = .reducedMotionDisabled
                }
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                        isDropped = true
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        if !onSucceedCalled {
                            onSucceed?()
                            onSucceedCalled = true
                        }
                    }
                }
            }
        }
    }
    
    enum ReducedMotionState {
        case started
        case reducedMotionEnabled
        case reducedMotionDisabled
    }
}
