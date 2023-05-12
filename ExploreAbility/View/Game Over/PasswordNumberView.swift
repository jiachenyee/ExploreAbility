//
//  PasswordNumberView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 12/5/23.
//

import SwiftUI

struct PasswordNumberButton: View {
    
    let numberToLetter = ["", " ", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    
    let number: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Spacer()
                Text("\(number)")
                    .font(.system(size: 38, weight: .light))
                    .fontWeight(.bold)
                
                if !numberToLetter[number].isEmpty {
                    Text(numberToLetter[number])
                        .font(.system(size: 11, weight: .bold))
                        .kerning(1.5)
                        .padding(.top, -5)
                }
                
                Spacer()
            }
            .frame(width: 78, height: 78)
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(40)
        }
    }
}
