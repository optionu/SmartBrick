//
//  SBrickPlus.swift
//  SmartBricks
//
//  Created by Claus Höfele on 10.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

open class SBrickPlus: SBrick {
    override class func isValidDevice(manufacturerData: Data) -> Bool {
        return isValidDevice(manufacturerData: manufacturerData, testForSBrickPlus: true)
    }
}

extension SBrickPlus {
    open func motionSensor(for port: SBrickPort) -> SBrickMotionSensor {
        return SBrickMotionSensor(device: self, port: port)
    }
}
