//
//  LoggerView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI

struct LoggerView: View {
    
    @StateObject var loggerViewModel: Logger = .shared
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
        return dateFormatter
    }
    
    var body: some View {
        VStack {
            Text("Notifications")
                .padding(8)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            ScrollView {
                ForEach(loggerViewModel.log) { log in
                    HStack {
                        Image(systemName: log.imageName)
                            .frame(maxWidth: 32)
                            .font(.system(size: 21))
                        
                        Text(log.text)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(dateFormatter.string(from: log.date))
                    }
                    .textSelection(.enabled)
                    .foregroundColor(log.type.toTextColor())
                    .padding()
                    .background(log.type.toBackground())
                    .cornerRadius(8)
                }
                .padding(.horizontal, 8)
            }
        }
        .padding()
    }
}
