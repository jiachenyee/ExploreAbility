//
//  ExploreAbilityApp.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI
import FirebaseCore
import CoreHaptics

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static private(set) var instance: AppDelegate! = nil
    var supportsHaptics: Bool = false
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        AppDelegate.instance = self    // << here !!
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        return true
    }
}

@main
struct ExploreAbilityApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
                .statusBarHidden()
                .preferredColorScheme(.light)
        }
    }
}
