//
//  PrivateControllerView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 12/5/23.
//

import SwiftUI

struct PrivateControllerView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Nothing to see here.")
            Text("Make sure this view is kept out of view of the players.")
        }
    }
}
