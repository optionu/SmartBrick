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
    override public init(peripheral: CBPeripheral) {
        super.init(peripheral: peripheral)
    }
}

extension SBrick {
    open func motionSensor(for port: SBrickPort) -> SBrickMotionSensor {
        return SBrickMotionSensor(device: self, port: port)
    }
}
