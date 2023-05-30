//
//  GroupNextChallengeRequestRow.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 15/5/23.
//

import SwiftUI

struct GroupNextChallengeRequestRow: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var isPopoverPresented = false
    
    var nextChallengeRequest: NextChallenge
    
    var body: some View {
//        if let group = viewModel.groups.first(where: {
//            $0.id == nextChallengeRequest.groupId
//        }) {
//        }
        VStack(alignment: .leading) {
            Text("**\(nextChallengeRequest.groupId)** requested for the next challenge.")
                .font(.title2)
            Button("Assign") {
                isPopoverPresented.toggle()
            }
            .popover(isPresented: $isPopoverPresented) {
                SetUserNextBeaconLocationView(viewModel: viewModel, request: nextChallengeRequest)
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        
        Divider()
    }
}
