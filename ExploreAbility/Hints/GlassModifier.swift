//
//  GlassModifier.swift
//  ExploreAbility
//
//  Created by Muhammad Tafani Rabbani on 28/04/23.
//

import SwiftUI

struct ConvexGlassView: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
                .frame(height: 50)
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(colors: [.clear,.black.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                .cornerRadius(14)
                .shadow(color: .white.opacity(0.3), radius: 1, x: -1, y: -2)
                .shadow(color: .red.opacity(0.4), radius: 2, x: 2, y: 2)
        } else {
            // Fallback on earlier versions
            content
                .padding()
                .frame(height: 50)
                .cornerRadius(14)
                .shadow(color: .white, radius: 3, x: -3, y: -3)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
        }
    }
}

struct FlatGlassView : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 100)
            .cornerRadius(14)
            .background(
                Color.black.opacity(0.8)
                    .blur(radius: 10)
                    .shadow(color: .white, radius: 3, x: -3, y: -3)
                    .shadow(color: .black.opacity(0.4), radius: 3, x: 3, y: 3)
                    .cornerRadius(14)
            )
            
            
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.clear)
            .foregroundColor(Color.white)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
    }
}
struct FrozenButton: View {
    var action: () -> Void
    var text: String
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
          
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0 / 255, green: 94 / 255, blue: 149 / 255))
            .foregroundColor(.white)
            .padding(5)
            .border(Color(red: 0 / 255, green: 94 / 255, blue: 149 / 255), width: 5)
            .cornerRadius(15)
            .animation(.easeInOut(duration: 0.2))
        }
        .buttonStyle(CustomButtonStyle())
    }
}
