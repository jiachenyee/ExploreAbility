//
//  ContentView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        HSplitView {
            List {
                Text("Connected Groups")
                    .padding(.vertical)
                    .font(.title)
                    .fontWeight(.bold)
                
                Button {
                    
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Group Name")
                                .font(.title2)
                            HStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                Circle()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                    .background(.white.opacity(0.000000000000000000000000000000000000000000001))
                }
                .buttonStyle(.plain)
                
                Divider()
                
                Button {
                    
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Group Name")
                                .font(.title2)
                            HStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                Circle()
                                    .frame(width: 30, height: 30)
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
            .frame(maxWidth: 400)
            VSplitView {
                MapView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HSplitView {
                    CommandsView(viewModel: viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    LoggerView(loggerViewModel: viewModel.logger)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
