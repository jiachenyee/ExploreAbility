//
//  ExploreAbility_LiveActivityLiveActivity.swift
//  ExploreAbility LiveActivity
//
//  Created by Jia Chen Yee on 4/5/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            let completedChallenges = context.state.completedChallenges
            let challenge = context.state.currentGameState
            
            ZStack {
                LinearGradient(colors: [
                    Color.white,
                    Color.black
                ], startPoint: .top, endPoint: .bottom)
                LinearGradient(colors: [
                    challenge.toColor(),
                    challenge.toColor().opacity(0.5)
                ], startPoint: .top, endPoint: .bottom)
                Color.black.opacity(0.7)
                VStack {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 21, height: 21)
                            Image("accessibility")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18)
                        }
                        Text("ExploreAbility")
                            .font(.system(size: 18, weight: .bold))
                            
                        Spacer()
                        HStack(spacing: -4) {
                            Circle()
                                .stroke(challenge.toColor(), style: .init(lineWidth: 3, lineCap: .round, dash: [5, 7]))
                                .frame(width: 32 - 3, height: 32 - 3)
                            
                            ForEach(completedChallenges, id: \.self) { challenge in
                                ZStack {
                                    Circle()
                                        .fill(challenge.toColor())
                                    
                                    Image(systemName: challenge.toIcon())
                                        .font(.system(size: 12))
                                }
                                .frame(width: 32, height: 32)
                            }
                        }
                    }
                    
                    Rectangle()
                        .fill(.white)
                        .frame(height: 0.5)
                        .padding(.vertical, 4)
                    
                    HStack {
                        VStack {
                            Text(context.state.challengeStart, style: .relative)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(challenge.toColor())
                            HStack(spacing: 0) {
                                Text("Stuck? ")
                                Text("Use a hint")
                                    .foregroundColor(challenge.toColor())
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .font(.system(size: 12, weight: .medium))
                        }
                        
                        VStack(alignment: .trailing) {
                            Text("\(5 - completedChallenges.count) more challenges")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text("No pressure")
                                .font(.system(size: 12, weight: .medium))
                        }
                        
                    }
                    
                    
                }
                .foregroundColor(.white)
                .padding()
            }
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                let completedChallenges = context.state.completedChallenges
                let challenge = context.state.currentGameState
                
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(context.attributes.startDate, style: .relative)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(challenge.toColor())
                    }
                    .padding(8)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        HStack(spacing: 0) {
                            Text("Stuck? ")
                            Text("Use a hint")
                                .foregroundColor(challenge.toColor())
                            Spacer()
                        }
                        .font(.system(size: 12, weight: .bold))
                        
                        Spacer()
                        HStack(spacing: -4) {
                            Circle()
                                .stroke(challenge.toColor(), style: .init(lineWidth: 3, lineCap: .round, dash: [5, 7]))
                                .frame(width: 32 - 3, height: 32 - 3)
                            
                            ForEach(completedChallenges, id: \.self) { challenge in
                                ZStack {
                                    Circle()
                                        .fill(challenge.toColor())
                                    
                                    Image(systemName: challenge.toIcon())
                                        .font(.system(size: 12))
                                }
                                .frame(width: 32, height: 32)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(5 - completedChallenges.count) more challenges")
                                    .font(.system(size: 16, weight: .bold))
                                
                                Text("No pressure")
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                    }
                    .padding(8)
                }
            } compactLeading: {
                Circle()
                    .fill(context.state.currentGameState.toColor())
                    .frame(width: 24, height: 24)
            } compactTrailing: {
                ZStack {
                    Circle()
                        .fill(.gray)
                        .opacity(0.5)
                    
                    let completedChallenges = context.state.completedChallenges
                    
                    VStack(spacing: completedChallenges.count == 3 ? -1 : 0) {
                        HStack(spacing: 0) {
                            ChallengeBallView(challenges: completedChallenges, index: 0)
                            ChallengeBallView(challenges: completedChallenges, index: 1)
                        }
                        HStack(spacing: 0) {
                            ChallengeBallView(challenges: completedChallenges, index: 2)
                            ChallengeBallView(challenges: completedChallenges, index: 3)
                        }
                    }
                }
                .frame(width: 24, height: 24)
            } minimal: {
                ZStack {
                    Circle()
                        .trim(from: 0, to: Double(context.state.completedChallenges.count) / 5)
                        .stroke(.white.opacity(0.5), style: .init(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(270))
                        .frame(width: 24, height: 24)
                    Circle()
                        .fill(context.state.currentGameState.toColor())
                        .frame(width: 16, height: 16)
                }
                
            }
            .keylineTint(context.state.currentGameState.toColor())
        }
    }
}

struct ExploreAbility_LiveActivityLiveActivity_Previews: PreviewProvider {
    static let attributes = LiveActivityAttributes()
    static let contentState = LiveActivityAttributes.ContentState(currentGameState: .voiceOver, completedChallenges: [.voiceOver, .reduceMotion, .closedCaptions, .textSize])

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
