//
//  ViewModel+MessageHandler.swift
//  ExploreAbility
//
//  Created by Jia Chen Yee on 1/5/23.
//

import Foundation
import MultipeerConnectivity

extension ViewModel {
    func didReceiveData(_ data: Data, from peerID: MCPeerID) {
        let decoder = JSONDecoder()
        do {
            let clientMessage = try decoder.decode(ClientMessage.self, from: data)
            
            switch clientMessage.payload {
            case .hello(let helloMessage):
                receivedHelloMessage(helloMessage, from: peerID)
                
                logger.addLog("Received Hello Message from \(peerID.displayName)", imageName: "hand.wave")
                
            case .heartbeat(let heartbeatMessage):
                receivedHeartbeatMessage(heartbeatMessage, from: peerID)
                
            case .challengeCompletion(_):
                break
            }
            
        } catch {
            logger.addLog("Unable to decode data from \(peerID.displayName): \(data.count) bytes", imageName: "questionmark.circle")
        }
    }
    
    fileprivate func receivedHelloMessage(_ helloMessage: HelloClientMessage, from peerID: MCPeerID) {
        Task {
            await MainActor.run {
                groups.append(Group(name: helloMessage.groupName, peerID: peerID))
            }
        }
        
        do {
            let sessionInfo = SessionInfoConsoleMessage(hostID: mcSession.myPeerID.displayName,
                                                        location: location)
            
            let data = try ConsoleMessage(payload: .sessionInfo(sessionInfo)).toData()
            
            try mcSession.send(data, toPeers: [peerID], with: .reliable)
        } catch {
            logger.addLog(.critical, "Error responding to Hello: \(error.localizedDescription)", imageName: "waveform.badge.exclamationmark")
        }
    }
    
    fileprivate func receivedHeartbeatMessage(_ heartbeatMessage: HeartbeatClientMessage, from peerID: MCPeerID) {
        guard let groupIndex = groups.firstIndex(where: {
            $0.peerID == peerID
        }) else { return }
        
        let locationData = heartbeatMessage.beaconDistances.enumerated().compactMap { n, distance in
            if let maxDistance = distance.maxRadius(),
               let position = beaconPositions[n] {
                
                return LocationData(position: position, distance: maxDistance)
            }
            
            return nil
        }
        
        #warning("TODO: Incorporate GPS location into calculation and append to `locationData`")
        
        let position = calculatePosition(using: locationData, date: heartbeatMessage.date)
        
        // Update group info
        Task {
            await MainActor.run {
                groups[groupIndex].compassHeading = heartbeatMessage.trueHeading
                groups[groupIndex].currentState = heartbeatMessage.gameState
                groups[groupIndex].position = position
                groups[groupIndex].lastUpdated = .now
            }
        }
        
        do {
            let positionResponse = PositionResponseConsoleMessage(position: position)
            
            let data = try ConsoleMessage(payload: .positionResponse(positionResponse)).toData()
            
            try mcSession.send(data, toPeers: [peerID], with: .unreliable)
        } catch {
            logger.addLog(.critical, "Error responding to position response: \(error.localizedDescription)", imageName: "waveform.badge.exclamationmark")
        }
    }
    
    struct LocationData {
        var position: Position
        var distance: Double
    }
    
    func calculatePosition(using locationData: [LocationData], date: Date) -> IPSPosition {
        // Check if we have at least 3 beacons
        if locationData.count < 3 {
            fatalError("At least 3 beacons are required for trilateration")
        }
        
        // Find the weighted centroid
        var sumWeightedX = 0.0
        var sumWeightedY = 0.0
        var sumWeights = 0.0
        
        for beacon in locationData {
            let weight = 1.0 / (beacon.distance * beacon.distance)
            sumWeightedX += beacon.position.x * weight
            sumWeightedY += beacon.position.y * weight
            sumWeights += weight
        }
        
        let centroidX = sumWeightedX / sumWeights
        let centroidY = sumWeightedY / sumWeights
        let centroid = Position(x: centroidX, y: centroidY)
        
        // Create that circle thing that mapping apps do around points
        var errorEstimate = 0.0
        
        for beacon in locationData {
            let deltaX = beacon.position.x - centroidX
            let deltaY = beacon.position.y - centroidY
            let distanceError = sqrt(deltaX * deltaX + deltaY * deltaY) - beacon.distance
            errorEstimate += distanceError * distanceError
        }
        errorEstimate = sqrt(errorEstimate / Double(locationData.count))
        
        return IPSPosition(position: centroid, error: errorEstimate, date: date)
    }
}
