//
//  SBrick.swift
//  SmartBricks
//
//  Created by Claus Höfele on 04/04/17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol SmartBrick: class {
    var peripheral: CBPeripheral { get }
    
    func prepareConnection(completionHandler: @escaping (() -> Void))
}

// voltage, temperature

public protocol InputOutput {
}

public protocol MotionSensor: InputOutput {
    func startReceivingData()
}

public protocol Light: InputOutput {
    func updateBrightness(_ brightness: UInt8)
}

public enum MotorDirection: UInt8 {
    // Viewed from the drive end
    case clockwise = 0x00, counterclockwise = 0x01
}

public protocol Motor: InputOutput {
    func drive(direction: MotorDirection, power: UInt8)
    func `break`()
}
