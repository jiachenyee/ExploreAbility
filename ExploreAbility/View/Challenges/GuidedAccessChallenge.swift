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
    
    @State var isGuidedAccessEnabled = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.purple)
                    .frame(width: isGuidedAccessEnabled ? 200 : 100, height: isGuidedAccessEnabled ? 200 : 100)
                Image(systemName: isGuidedAccessEnabled ? "lock.ipad" : "lock.open.ipad")
                    .font(.system(size: 48))
                    .foregroundColor(.white)
            }
            
            if isGuidedAccessEnabled {
                Text("Let me out!")
                    .font(.system(size: 32))
                Text("I'm trapped!")
                    .font(.system(size: 32))
            } else {
                Text("Don't leave me.")
                    .font(.system(size: 32))
                Text("Don't click on *that*.")
                    .font(.system(size: 32))
            }
        }
        .font(.system(size: 17))
        .foregroundColor(.white)
        .onReceive(publisher) { _ in
            withAnimation {
                isGuidedAccessEnabled = UIAccessibility.isGuidedAccessEnabled
            }
        }
    }
}
