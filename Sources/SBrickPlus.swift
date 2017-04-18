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
    public init?(peripheral: CBPeripheral, manufacturerData: Data) {
        super.init(peripheral: peripheral, manufacturerData: manufacturerData, shouldBePlus: true)
    }
}

extension SBrick {
    open func motionSensor(for channel: SBrickChannel) -> SBrickMotionSensor {
        return SBrickMotionSensor(device: self, channel: channel)
    }
}
