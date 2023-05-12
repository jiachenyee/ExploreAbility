//
//  CommandView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct DashboardElement<Content: View, IconImage: View>: View {
    
    @ViewBuilder
    var icon: () -> IconImage
    var title: String
    
    @ViewBuilder
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                icon()
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            content()
        }
        .frame(height: 200, alignment: .top)
        .padding()
        .background(.white.opacity(0.1))
        .cornerRadius(8)
    }
}
