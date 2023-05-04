//
//  GroupView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct GroupView: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var group: Group
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .fill(group.isOnline ? .green : .red)
                                .frame(width: 20, height: 20)
                            
                            Text(group.name)
                                .font(.title2)
                        }
                        
                        if let lastUpdated = group.lastUpdated {
                            HStack(spacing: 0) {
                                Text("Last Updated: ")
                                Text(lastUpdated, style: .offset)
                            }
                        }
                        
                        HStack(spacing: -8) {
                            ForEach(group.completedChallenges, id: \.self) { challenge in
                                ZStack {
                                    Circle()
                                        .fill(challenge.toColor())
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: challenge.toIcon())
                                        .font(.system(size: 35))
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.forward")
                }
                .background(.white.opacity(0.000000000000000000000000000000000000000000001))
            }
            .buttonStyle(.plain)
            
            if group.needsNextChallenge {
                Button("Set Next Challenge") {
                    
                }
            }
            
            Divider()
        }
    }
}
