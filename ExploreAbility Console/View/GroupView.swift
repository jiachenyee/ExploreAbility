//
//  GroupView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct GroupView: View {
    
    var group: Group
    
    var body: some View {
        Button {
            
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(group.name)
                        .font(.title2)
                    
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
                    }
                }
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .background(.white.opacity(0.000000000000000000000000000000000000000000001))
        }
        .buttonStyle(.plain)
        
        Divider()
    }
}
