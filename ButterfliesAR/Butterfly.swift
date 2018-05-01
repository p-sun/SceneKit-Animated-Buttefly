//
//  Butterfly.swift
//  ButterfliesAR
//
//  Created by TSD064 on 2018-04-30.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import SceneKit

class Butterfly {
    
    struct SingleFlapCycle {
        let rightWingDownUp: SCNAction
        let leftWingDownUp: SCNAction
    }
    
    struct ButterflyStrokes {
        var rightWingActions = [SCNAction]()
        var leftWingActions = [SCNAction]()
        var totalDuration: TimeInterval = 0
        
        init() {
            addFlyingActions()
            addGetToGlidingPosition()
            addGlideAction()
        }
        
        mutating func addFlyingActions() {
            let numFlaps = Int.random(min: 5, max: 14)
            for _ in 0..<numFlaps {
                let flapDuration = TimeInterval.random(min: 0.07, max: 0.18)
                addFlapAction(duration: flapDuration)
                totalDuration += flapDuration
            }
        }

        private mutating func addFlapAction(duration: TimeInterval) {
            func singleFlapCycle(downRotation: CGFloat, upRotation: CGFloat, duration: TimeInterval) -> SingleFlapCycle {
                let rightDownStoke = SCNAction.rotateTo(x: -downRotation.degreesToRadians, y: 0, z: 0, duration: duration)
                let rightUpStoke = SCNAction.rotateTo(x: -upRotation.degreesToRadians, y: 0, z: 0, duration: duration)
                
                let leftDownStoke = SCNAction.rotateTo(x: downRotation.degreesToRadians, y: 0, z: 0, duration: duration)
                let leftUpStoke = SCNAction.rotateTo(x: upRotation.degreesToRadians, y: 0, z: 0, duration: duration)
                
                let rightWingDownUp = SCNAction.sequence([rightDownStoke, rightUpStoke])
                let leftWingDownUp = SCNAction.sequence([leftDownStoke, leftUpStoke])
                
                return SingleFlapCycle(rightWingDownUp: rightWingDownUp, leftWingDownUp: leftWingDownUp)
            }
            
            let downRotation = CGFloat(Int.random(min: 100, max: 120))
            let flap = singleFlapCycle(downRotation: downRotation, upRotation: 6, duration: duration)
            rightWingActions.append(flap.rightWingDownUp)
            leftWingActions.append(flap.leftWingDownUp)
        }
        
        private mutating func addGetToGlidingPosition() {
            let glideDuration = TimeInterval.random(min: 0.1, max: 0.15)

            let wingRotation = CGFloat(Int.random(min: 50, max: 80))
            let rightWingAction = SCNAction.rotateTo(x: -wingRotation.degreesToRadians, y: 0, z: 0, duration: glideDuration)
            let leftWingAction = SCNAction.rotateTo(x: wingRotation.degreesToRadians, y: 0, z: 0, duration: glideDuration)
            
            rightWingActions.append(rightWingAction)
            leftWingActions.append(leftWingAction)
            
            totalDuration += glideDuration
        }
        
        private mutating func addGlideAction() {
            let glideDuration = TimeInterval.random(min: 2.0, max: 3.6)
            
            let wingRotation = CGFloat(Int.random(min: -15, max: -10))
            let rightWingAction = SCNAction.rotateBy(x: -wingRotation.degreesToRadians, y: 0, z: 0, duration: glideDuration)
            let leftWingAction = SCNAction.rotateBy(x: wingRotation.degreesToRadians, y: 0, z: 0, duration: glideDuration)
            
            rightWingActions.append(rightWingAction)
            leftWingActions.append(leftWingAction)
            
            totalDuration += glideDuration
        }
    }
    
    let butterflyNode: SCNNode
    private let rightWing: SCNNode
    private let leftWing: SCNNode
    
    init() {
        let butterflyScene = SCNScene(named: "art.scnassets/pastelButterfly/butterfly.scn")!
        butterflyNode = butterflyScene.rootNode.childNode(withName: "butterflyRoot", recursively: true)!
        rightWing = butterflyNode.childNode(withName: "rightWing", recursively: false)!
        leftWing = butterflyNode.childNode(withName: "leftWing", recursively: false)!

        setupWings(rotation: 10)
    }

    @objc func playAnimation() {
        let flyThenGlide = ButterflyStrokes()
        rightWing.runAction(SCNAction.sequence(flyThenGlide.rightWingActions))
        leftWing.runAction(SCNAction.sequence(flyThenGlide.leftWingActions))
        
        Timer.scheduledTimer(timeInterval: flyThenGlide.totalDuration, target: self, selector: #selector(playAnimation), userInfo: nil, repeats: false)
    }
    
    private func setupWings(rotation: Float) {
        rightWing.eulerAngles.x = -rotation.degreesToRadians
        leftWing.eulerAngles.x = rotation.degreesToRadians
    }
}

extension Int {
    // Random number between 0 and the max, inclusive
    static func random(max: Int) -> Int {
        let max = UInt32(max)
        return Int(arc4random_uniform(max + 1) + 1)
    }
    
    // Random number between min and the max, inclusive
    static func random(min: Int, max: Int) -> Int {
        assert(min <= max)
        let diff = max - min
        return min + random(max: diff)
    }
}

extension BinaryFloatingPoint {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Self {
        return Self(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Self, max: Self) -> Self {
        return Self.random * (max - min) + min
    }
}
