//
//  SetBeaconView+DropDelegate.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 2/5/23.
//

import Foundation
import SwiftUI

extension SetBeaconsView {
    struct BeaconDropDelegate: DropDelegate {
        
        var onDrop: ((Int, CGPoint) -> ())?
        
        func performDrop(info: DropInfo) -> Bool {
            guard let itemProvider = info.itemProviders(for: [.plainText]).first else { return false }
            
            _ = itemProvider.loadTransferable(type: String.self) { result in
                switch result {
                case .success(let string):
                    guard let value = Int(string) else { return }
                    
                    Task {
                        await onDrop?(value, info.location)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
            return true
        }
    }
}
