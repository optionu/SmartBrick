//
//  SBrick.swift
//  SmartBricks
//
//  Created by Claus Höfele on 04/04/17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

// Enum instead?
public protocol SmartBrick {
}

open class SBrick: SmartBrick {
    public enum Port: Int {
        case A, B, C, D
    }

//    open func retrieveSensorValue(port: Port)
//    open func startReceivingSensorValues(port: Port)
//    open func updateActuator(value: Double, atPort: Port)

}

open class SBrickPlus: SBrick {

}
