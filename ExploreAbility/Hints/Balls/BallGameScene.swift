//
//  GameScene.swift
//  SwiftUIWithSprite
//
//  Created by Muhammad Tafani Rabbani on 22/05/23.
//

import Foundation
import SpriteKit
import CoreHaptics
import CoreMotion

class GameScene : SKScene,SKPhysicsContactDelegate{
    
    let ball = SKSpriteNode(imageNamed: "ball")
    let ball2 = SKSpriteNode(imageNamed: "ball")
    let ball3 = SKSpriteNode(imageNamed: "ball")
    
    private let kMaxVelocity: Float = 500
    lazy var supportsHaptics: Bool = {
        return AppDelegate.instance.supportsHaptics
    }()
    // Haptic Engine & State:
    private var engine: CHHapticEngine!
    private var engineNeedsStart = true
    private let motionManager = CMMotionManager()
    
    enum BitmaskScene:UInt32{
        case frame = 0b1
        case ball2 = 0b100
        case ball3 = 0b1000
        case ball = 0b10000
    }
    
    override func didMove(to view: SKView) {
        createAndStartHapticEngine()
        motionManager.startAccelerometerUpdates()
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.contactDelegate = self
//        physicsWorld.gravity = .zero
        
        
        ball.position = CGPoint(x: size.width/2, y: size.height/2)
        ball.zPosition = 10
        ball.size = CGSize(width: 80, height: 80)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 0.4
        ball.physicsBody?.linearDamping = 0.1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.allowsRotation = true
        addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: -150, dy: 150))
        ball.physicsBody?.categoryBitMask = BitmaskScene.ball.rawValue
        ball.physicsBody?.contactTestBitMask = BitmaskScene.ball2.rawValue | BitmaskScene.ball3.rawValue | BitmaskScene.frame.rawValue
        ball.physicsBody?.collisionBitMask = BitmaskScene.ball2.rawValue | BitmaskScene.ball3.rawValue | BitmaskScene.frame.rawValue
        
        ball2.position = CGPoint(x: size.width/2, y: size.height/2)
        ball2.zPosition = 10
        ball2.size = CGSize(width: 80, height: 80)
        ball2.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball2.physicsBody?.friction = 0
        ball2.physicsBody?.restitution = 0.45
        
        ball2.physicsBody?.linearDamping = 0
        ball2.physicsBody?.angularDamping = 0
        ball2.physicsBody?.allowsRotation = true
        addChild(ball2)
        ball2.physicsBody?.categoryBitMask = BitmaskScene.ball2.rawValue
        ball2.physicsBody?.contactTestBitMask = BitmaskScene.ball.rawValue | BitmaskScene.ball3.rawValue | BitmaskScene.frame.rawValue
        ball2.physicsBody?.collisionBitMask = BitmaskScene.ball.rawValue | BitmaskScene.ball3.rawValue | BitmaskScene.frame.rawValue
        
        ball3.position = CGPoint(x: size.width/2, y: size.height/2)
        ball3.zPosition = 10
        ball3.size = CGSize(width: 80, height: 80)
        ball3.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball3.physicsBody?.friction = 0
        ball3.physicsBody?.restitution = 0.45
        
        ball3.physicsBody?.linearDamping = 0
        ball3.physicsBody?.angularDamping = 0
        ball3.physicsBody?.allowsRotation = true
        addChild(ball3)
        ball3.physicsBody?.categoryBitMask = BitmaskScene.ball3.rawValue
        ball3.physicsBody?.contactTestBitMask = BitmaskScene.ball.rawValue | BitmaskScene.ball2.rawValue | BitmaskScene.frame.rawValue
        ball3.physicsBody?.collisionBitMask = BitmaskScene.ball.rawValue | BitmaskScene.ball2.rawValue | BitmaskScene.frame.rawValue
//        ball2.physicsBody?.applyImpulse(CGVector(dx: -150, dy: 150))
        
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        
        frame.categoryBitMask = BitmaskScene.frame.rawValue
        frame.contactTestBitMask = BitmaskScene.ball.rawValue | BitmaskScene.ball2.rawValue | BitmaskScene.ball3.rawValue
        frame.collisionBitMask = BitmaskScene.ball.rawValue | BitmaskScene.ball2.rawValue | BitmaskScene.ball3.rawValue
        self.physicsBody = frame
    }
    
    

    
    private func createAndStartHapticEngine() {
        guard supportsHaptics else { return }
        
        // Create and configure a haptic engine.
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        // The stopped handler alerts engine stoppage.
        engine.stoppedHandler = { reason in
            print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt.")
            case .applicationSuspended:
                print("Application suspended.")
            case .idleTimeout:
                print("Idle timeout.")
            case .notifyWhenFinished:
                print("Finished.")
            case .systemError:
                print("System error.")
            case .engineDestroyed:
                print("Engine destroyed.")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            @unknown default:
                print("Unknown error")
            }
            
            // Indicate that the next time the app requires a haptic, the app must call engine.start().
            self.engineNeedsStart = true
        }
        
        // The reset handler notifies the app that it must reload all its content.
        // If necessary, it recreates all players and restarts the engine in response to a server restart.
        engine.resetHandler = {
            print("The engine reset --> Restarting now!")
            
            // Tell the rest of the app to start the engine the next time a haptic is necessary.
            self.engineNeedsStart = true
        }
        
        // Start haptic engine to prepare for use.
        do {
            try engine.start()
            print("It is started")
            
            // Indicate that the next time the app requires a haptic, the app doesn't need to call engine.start().
            engineNeedsStart = false
        } catch let error {
            print("The engine failed to start with error: \(error)")
        }
    }
    
    func collision(velocity:CGPoint){
        // Play collision haptic for supported devices.
        guard supportsHaptics else { return }
        
        // Play haptic here.
        do {
            // Start the engine if necessary.
            if engineNeedsStart {
                try engine.start()
                engineNeedsStart = false
            }
            
            // Map the bounce velocity to intensity & sharpness.
//            let velocity = bounce.linearVelocity(for: item)
            let xVelocity = Float(velocity.x)
            let yVelocity = Float(velocity.y)
            
            // Normalize magnitude to map one number to haptic parameters:
            let magnitude = sqrtf(xVelocity * xVelocity + yVelocity * yVelocity)
            let normalizedMagnitude = min(max(Float(magnitude) / kMaxVelocity, 0.0), 1.0)
            
            // Create a haptic pattern player from normalized magnitude.
            let hapticPlayer = try playerForMagnitude(normalizedMagnitude)
            
            // Start player, fire and forget
            try hapticPlayer?.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Haptic Playback Error: \(error)")
        }
    }
    
    private func playerForMagnitude(_ magnitude: Float) throws -> CHHapticPatternPlayer? {
        let volume = linearInterpolation(alpha: magnitude, min: 0.1, max: 0.4)
        let decay: Float = linearInterpolation(alpha: magnitude, min: 0.0, max: 0.1)
        let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
            CHHapticEventParameter(parameterID: .audioPitch, value: -0.15),
            CHHapticEventParameter(parameterID: .audioVolume, value: volume),
            CHHapticEventParameter(parameterID: .decayTime, value: decay),
            CHHapticEventParameter(parameterID: .sustained, value: 0)
        ], relativeTime: 0)
        
        let sharpness = linearInterpolation(alpha: magnitude, min: 0.9, max: 0.5)
        let intensity = linearInterpolation(alpha: magnitude, min: 0.375, max: 1.0)
        let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        ], relativeTime: 0)
        
        let pattern = try CHHapticPattern(events: [audioEvent, hapticEvent], parameters: [])
        return try engine.makePlayer(with: pattern)
    }
    
    private func linearInterpolation(alpha: Float, min: Float, max: Float) -> Float {
        return min + alpha * (max - min)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other : SKPhysicsBody
        let ball : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            other = contact.bodyA
            ball = contact.bodyB
        }else{
            other = contact.bodyB
            ball = contact.bodyA
        }
        
        if ball.categoryBitMask == BitmaskScene.ball.rawValue{
            collision(velocity: ball.node?.position ?? CGPoint())
        }
        if ball.categoryBitMask == BitmaskScene.ball2.rawValue{
            collision(velocity: ball.node?.position ?? CGPoint())
        }
        if ball.categoryBitMask == BitmaskScene.ball3.rawValue{
            collision(velocity: ball.node?.position ?? CGPoint())
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
            }
    }
}
