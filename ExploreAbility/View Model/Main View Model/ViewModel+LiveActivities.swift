//
//  ViewModel+LiveActivities.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 4/5/23.
//

import Foundation
import ActivityKit

extension ViewModel {
    func startLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let initialContentState = LiveActivityAttributes.ContentState(currentGameState: gameState,
                                                                          completedChallenges: completedChallenges)
            let activityAttributes = LiveActivityAttributes()
            
            let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
            
            do {
                liveActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
                
                print("Requested Live Activity \(String(describing: liveActivity!.id)).")
            } catch {
                print("Error requesting Live Activity \(error.localizedDescription).")
            }
        }
        
    }
    
    func updateLiveActivity() {
        let contentState = LiveActivityAttributes.ContentState(currentGameState: gameState,
                                                               completedChallenges: completedChallenges)
        Task {
            await liveActivity?.update(ActivityContent(state: contentState, staleDate: nil, relevanceScore: 1))
        }
    }
    
    func deleteLiveActivity() {
        Task {
            let activities = Activity<LiveActivityAttributes>.activities
            for activity in activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
}
