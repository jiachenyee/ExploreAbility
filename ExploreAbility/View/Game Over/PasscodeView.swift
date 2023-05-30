//
//  PasscodeView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 11/5/23.
//

import SwiftUI

struct PasswordView: View {
    
    @State private var password = ""
    @State private var offset = 0.0
    
    @Binding var isVisible: Bool
    
    var onUnlock: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .background(.thinMaterial)
            VStack {
                Text("Enter Passcode")
                    .font(.system(size: 22, weight: .regular))
                    .padding()
                    .foregroundColor(.white)
                    .padding(.top)
                
                HStack(spacing: 23) {
                    ForEach(0..<6) { index in
                        Image(systemName: password.count - 1 < index ? "circle" : "circle.fill")
                    }
                }
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal)
                .foregroundColor(.white)
                .offset(x: offset)
                
                VStack(spacing: 18) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 21) {
                            ForEach(1..<4) { column in
                                PasswordNumberButton(number: row * 3 + column, action: {
                                    if password.count < 6 {
                                        password.append("\(row * 3 + column)")
                                    }
                                })
                            }
                        }
                    }
                    PasswordNumberButton(number: 0, action: {
                        if password.count < 6 {
                            password.append("\(0)")
                        }
                    })
                }
                .padding(.vertical, 77)
            }
            .opacity(0.8)
            
            VStack {
                Spacer()
                HStack {
                    Text("Emergency")
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    if password.isEmpty {
                        Button("Cancel") {
                            withAnimation {
                                isVisible = false
                            }
                        }
                    } else {
                        Button("Delete") {
                            _ = withAnimation {
                                password.removeLast()
                            }
                        }
                    }
                }
                .font(.system(size: 17))
                .frame(width: 270)
                .padding()
            }
            .foregroundColor(.white)
        }
        .onChange(of: password) { newValue in
            guard newValue.count == 6 else { return }
            if newValue != String(ExploreAbility.password) {
                // Access Denied
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                
                withAnimation(.easeIn(duration: 0.2)) {
                    offset = -50
                }
                
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
                        offset = 0
                    }
                    
                    password = ""
                }
            } else {
                // Access Granted
                onUnlock()
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
    }
}
