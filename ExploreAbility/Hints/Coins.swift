//
//  File.swift
//  ExploreAbility
//
//  Created by Muhammad Tafani Rabbani on 28/04/23.
//


import SwiftUI

struct CoinsView: View {
    var body: some View {
        
        Image(systemName: "centsign.circle.fill")
            .resizable()
            .foregroundColor(.yellow).opacity(0.8)
            .frame(width: 30, height: 30, alignment: .center)

    }
}
struct CoinsAnimating: View{
    @State private var isRotating = false
    private var xAxis: CGFloat = 1.0 // nod face back and forth
    private var zAxis: CGFloat = 1.0 // rotate face left and right like a dial
    
    var body: some View {
        ZStack {
            CoinsView()
        }
        // Rotate clock back and forth over x axis
        .rotation3DEffect(.degrees(Double(isRotating ? Int.random(in: 20...50) : Int.random(in: 20...50) * -1)), axis: (x: xAxis, y: 0, z:  0))
        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isRotating)
        // Spin clock face left and right over z axis
        .rotation3DEffect(.degrees(Double(isRotating ? Int.random(in: 20...50) : Int.random(in: 20...50) * -1)), axis: (x: 0, y: 0, z:  zAxis))
        .animation(.easeInOut(duration: Double.random(in: 1...2)).repeatForever(autoreverses: true).delay(1.0), value: isRotating)
        .onAppear { isRotating.toggle() }
    }
}
