//
//  3DHelpers.swift
//  ButterfliesAR
//
//  Created by TSD064 on 2018-04-30.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import SceneKit


// MARK: - Helpers
extension SCNNode {
    func directChildNode(withName name: String) -> SCNNode? {
        for child in childNodes {
            if child.name?.contains(name) == true {
                return child
            }
        }
        return nil
    }
}

public extension SCNVector3 {
    public var degreesToRadians: SCNVector3 {
        return SCNVector3Make(x.degreesToRadians,
                              y.degreesToRadians,
                              z.degreesToRadians)
    }
    public var radiansToDegrees: SCNVector3 {
        return SCNVector3Make(x.radiansToDegrees,
                              y.radiansToDegrees,
                              z.radiansToDegrees)
    }
}

public extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}
