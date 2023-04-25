//
//  TextSizeChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct TextSizeChallenge: View {
    
    var namespace: Namespace.ID
    
    var onSucceed: (() -> ())?
    
    private let publisher = NotificationCenter.default.publisher(for: UIContentSizeCategory.didChangeNotification)
    
    private let fontSizes: [Double] = [6, 8, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    private let prompts: [String] = [
        "You're making it harder to read.",
        "Wrong way ⚠️!",
        "This is a little hard to read",
        "A little better, but still hard to read",
        "Larger…",
        "Even larger…",
        "Can we go even larger?",
        "All the way up",
        "Still think it's too small",
        "As large as possible!",
        "Almost there.",
        "You did it!"
    ]
    
    @State private var userFontSize = 2
    @State private var circleScale = 1.0
    @State private var circleOpacity = 0.3
    
    @State private var circleOverwriteSize = 0.0
    
    @State private var isDropped = false
    @State private var backgroundColor = Color.white
    
    @State private var didSucceed = false
    
    var body: some View {
        GeometryReader { context in
            backgroundColor
            ZStack {
                let circleDiameter = circleOverwriteSize == 0 ? min(context.size.width, context.size.height) / (userFontSize < 11 ? Double(9 - (userFontSize - 2)) : 1.0) : circleOverwriteSize
                
                Circle()
                    .fill(.blue)
                    .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                    .matchedGeometryEffect(id: "TextSizeChallengeBubble", in: namespace)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .opacity(circleOpacity)
                    .scaleEffect(circleScale)
                
                Text(prompts[userFontSize])
                    .font(.system(size: fontSizes[userFontSize]))
                    .multilineTextAlignment(.center)
                    .mask {
                        let maskCircleDiameter = circleOverwriteSize == 0 ? min(context.size.width, context.size.height) : circleOverwriteSize
                        
                        Circle()
                            .frame(width: maskCircleDiameter, height: maskCircleDiameter)
                            .scaleEffect(circleScale)
                    }
            }
            .offset(y: isDropped ? context.size.height / 2 - 42 : 0)
        }
        .onReceive(publisher) { output in
            guard let value = output.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory,
                  !didSucceed else { return }
            
            withAnimation(.spring(dampingFraction: 0.5)) {
                switch value {
                case .extraSmall:
                    userFontSize = 0
                case .small:
                    userFontSize = 1
                case .medium:
                    userFontSize = 2
                case .large:
                    userFontSize = 3
                case .extraLarge:
                    userFontSize = 4
                case .extraExtraLarge:
                    userFontSize = 5
                case .extraExtraExtraLarge:
                    userFontSize = 6
                case .accessibilityMedium:
                    userFontSize = 7
                case .accessibilityLarge:
                    userFontSize = 8
                case .accessibilityExtraLarge:
                    userFontSize = 9
                case .accessibilityExtraExtraLarge:
                    userFontSize = 10
                case .accessibilityExtraExtraExtraLarge:
                    userFontSize = 11
                default: break
                }
            }
            
            if value == .accessibilityExtraExtraExtraLarge {
                didSucceed = true
                
                startSuccessAnimation()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func startSuccessAnimation() {
        withAnimation(.easeInOut(duration: 0.5)) {
            circleScale = 4
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            withAnimation {
                circleOpacity = 1
                circleScale = 1
                circleOverwriteSize = 20
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                    isDropped = true
                }
                withAnimation {
                    backgroundColor = .black
                }
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    onSucceed?()
                }
            }
        }
    }
}
