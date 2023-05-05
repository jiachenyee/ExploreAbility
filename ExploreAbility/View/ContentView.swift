//
//  ContentView.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 25/4/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @Namespace var namespace
    
    @StateObject var viewModel = ViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            switch viewModel.gameState {
            case .waitingRoom:
                WaitingRoomView(groupName: viewModel.groupName)
            case .groupSetUp:
                GroupSetupView(viewModel: viewModel)
            case .internalTest:
                DeveloperMenuConfirmationView(gameState: $viewModel.gameState)
            case .connection:
                ConnectionView(viewModel: viewModel)
            case .exploring:
                ExploringView(viewModel: viewModel, namespace: namespace)
            case .textSize:
                TextSizeChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
                        viewModel.gameState = .exploring
                        viewModel.completedChallenges.append(.textSize)
                    }
                }
            case .voiceOver:
                VoiceOverChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
                        viewModel.gameState = .exploring
                        viewModel.completedChallenges.append(.voiceOver)
                    }
                }
            case .closedCaptions:
                ClosedCaptionsChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
                        viewModel.gameState = .exploring
                        viewModel.completedChallenges.append(.closedCaptions)
                    }
                }
            case .reduceMotion:
                ReduceMotionChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
                        viewModel.gameState = .exploring
                        viewModel.completedChallenges.append(.reduceMotion)
                    }
                }
            case .guidedAccess:
                GuidedAccessChallenge(namespace: namespace) {
                    withAnimation(.easeOut(duration: 1)) {
                        viewModel.gameState = .exploring
                        viewModel.completedChallenges.append(.guidedAccess)
                    }
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .inactive: break
            case .active:
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            case .background:
//                if GameState.all.contains(viewModel.gameState) {
                    let content = UNMutableNotificationContent()
                    
                    content.title = "You've been gone for a while"
                    content.body = "Try using a hint to solve this challenge!"
                    
                    content.sound = .default
                    
                    // show this notification five seconds from now
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
                    
                    // choose a random identifier
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
//                }
            @unknown default: break
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
