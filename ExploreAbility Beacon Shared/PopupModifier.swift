//
//  PopupModifier.swift
//  ExploreAbility Beacon
//
//  Created by Jia Chen Yee on 26/4/23.
//

import Foundation
import SwiftUI

struct PopupModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .padding()
            .sheet(isPresented: $isPresented) {
                TransmittingView(isActive: $isPresented)
            }
        #else
        content
            .fullScreenCover(isPresented: $isPresented) {
                TransmittingView(isActive: $isPresented)
            }
        #endif
    }
}
