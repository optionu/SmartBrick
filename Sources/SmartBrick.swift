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
    var identifier: UUID { get }
    var name: String? { get }
}

open class SBrick: SmartBrick {
    open var identifier: UUID
    open let name: String?
    
    public init(identifier: UUID, name: String?) {
        self.identifier = identifier
        self.name = name
    }
    
    public enum Port: Int {
        case A, B, C, D
    }

//    open func retrieveSensorValue(port: Port)
//    open func startReceivingSensorValues(port: Port)
//    open func updateActuator(value: Double, atPort: Port)

}

open class SBrickPlus: SBrick {

}
