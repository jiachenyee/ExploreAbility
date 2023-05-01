//
//  MCBrowserView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import Foundation
import UIKit
import SwiftUI
import MultipeerConnectivity

struct MCBrowserView: UIViewControllerRepresentable {
    
    var session: MCSession
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> MCBrowserViewController {
        let vc = MCBrowserViewController(serviceType: MCConstant.service, session: session)
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MCBrowserViewControllerDelegate {
        
        var parent: MCBrowserView
        
        init(parent: MCBrowserView) {
            self.parent = parent
        }
        
        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            parent.dismiss()
        }
        
        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            parent.dismiss()
        }
    }
}
