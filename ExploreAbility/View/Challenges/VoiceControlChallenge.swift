//
//  VoiceControlChallenge.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 26/4/23.
//

import SwiftUI

struct VoiceControlChallenge: View {
    
    var namespace: Namespace.ID
    
    var onSucceed: (() -> ())?
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            HStack {
                Image(systemName: "hand.raised.slash.fill")
                Image(systemName: "quote.bubble")
            }
            .font(.system(size: 64))
            .foregroundColor(.red)
        }
    }
}
