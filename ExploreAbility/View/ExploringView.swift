//
//  ExploringView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct ExploringView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var namespace: Namespace.ID
    
    @State var isTextShown = false
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                if isTextShown {
                    Image(systemName: "eye.slash")
                        .font(.system(size: 32))
                    
                    Text("Put on your blindfolds")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24))
                }
                
                Spacer()
                HStack {
                    ForEach(viewModel.completedChallenges, id: \.rawValue) { challenge in
                        ZStack {
                            Circle()
                                .fill(challenge.toColor())
                                .frame(width: 30, height: 30)
                                .matchedGeometryEffect(id: challenge, in: namespace)
                            Image(systemName: challenge.toIcon())
                                .font(.system(size: 17))
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .onAppear {
                withAnimation {
                    isTextShown = true
                }
            }
        }
        .foregroundColor(.white)
    }
}
