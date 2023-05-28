//
//  PasswordDigitView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import SwiftUI

struct PasswordDigitView: View {
    let digit: Int?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.gray, lineWidth: 2)
                .frame(width: 60, height: 60)
            if let digit = digit {
                Text("\(digit)")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
    }
}
