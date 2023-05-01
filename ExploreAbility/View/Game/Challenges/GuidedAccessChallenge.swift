//
//  GuidedAccessChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 26/4/23.
//

import SwiftUI

struct GuidedAccessChallenge: View {
    
    var namespace: Namespace.ID
    
    var onSucceed: (() -> ())?
    
    private let publisher = NotificationCenter.default.publisher(for: UIAccessibility.guidedAccessStatusDidChangeNotification)
    
    @State private var stage = GuidedAccessStage.started
    @State private var isDropped = false
    
    var body: some View {
        GeometryReader { context in
            VStack {
                ZStack {
                    let circleDiameter = isDropped ? 20 : CGFloat(stage.rawValue) * 100
                    
                    Circle()
                        .fill(.purple)
                        .frame(width: circleDiameter, height: circleDiameter)
                        .matchedGeometryEffect(id: GameState.guidedAccess, in: namespace)
                        .offset(y: isDropped ? context.size.height / 2 - 42 : 0)
                    Image(systemName: stage == .guidedAccessEnabled ? "lock.ipad" : "lock.open.ipad")
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                }
                
                switch stage {
                case .started:
                    Text("Don't leave me.")
                        .multilineTextAlignment(.center)
                    Text("Don't click on *that*.")
                        .multilineTextAlignment(.center)
                    Text("Here, you can have my device.")
                        .multilineTextAlignment(.center)
                case .guidedAccessEnabled:
                    Text("Let me out!")
                        .font(.system(size: 32))
                    Text("I'm trapped!")
                        .font(.system(size: 32))
                case .completion: EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .font(.system(size: 17))
        .foregroundColor(.white)
        .onReceive(publisher) { _ in
            switch stage {
            case .started:
                if UIAccessibility.isGuidedAccessEnabled {
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        stage = .guidedAccessEnabled
                    }
                }
            case .guidedAccessEnabled:
                if !UIAccessibility.isGuidedAccessEnabled {
                    showCompletionAnimation()
                }
            case .completion:
                break
            }
        }
    }
    
    enum GuidedAccessStage: Int {
        case started = 1
        case guidedAccessEnabled = 2
        case completion = 3
    }
    
    func showCompletionAnimation() {
        withAnimation(.spring(dampingFraction: 0.5)) {
            stage = .completion
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                isDropped = true
            }
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                onSucceed?()
            }
        }
    }
}
