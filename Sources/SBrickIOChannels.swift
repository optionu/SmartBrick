//
//  SBrickInputOutputs.swift
//  SmartBricks
//
//  Created by Claus Höfele on 16.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

open class SBrickInputOutput {
    open let device: SBrick
    open let port: SBrickPort
    
    init(device: SBrick, port: SBrickPort) {
        self.device = device
        self.port = port
    }
}

public enum SBrickMotorDirection: UInt8 {
    // Viewed from the drive end
    case clockwise = 0x00, counterclockwise = 0x01
}

open class SBrickMotor: SBrickInputOutput, IOChannel {
    open func drive(direction: SBrickMotorDirection, power: UInt8) {
        let command = SBrickRemoteControlCommand.driveCommand(port: port, direction: direction, power: power)
        device.write(command)
    }
    
    open func `break`() {
        let command = SBrickRemoteControlCommand.breakCommand(port: port)
        device.write(command)
    }
}

open class SBrickQuickDrive: SBrickInputOutput, IOChannel {
    // Default order: 0, 1, 2, 3/A, C, B, D
    open func changePortMapping(port0: SBrickPort, port1: SBrickPort, port2: SBrickPort, port3: SBrickPort) {
        let command = SBrickRemoteControlCommand.quickDriveSetupCommand(port0: port0, port1: port1, port2: port2, port3: port3)
        device.write(command)
    }
    
    open func drive(portValues: [(direction: SBrickMotorDirection, power: UInt8)]) {
        let command = SBrickQuickDriveCommand(portValues: portValues)
        device.write(command)
    }
}

open class SBrickMotionSensor: SBrickInputOutput, IOChannel, SBrickDelegate {
    override init(device: SBrick, port: SBrickPort) {
        super.init(device: device, port: port)
        
        device.delegates.register(self, for: .ac2)
    }

    open func retrieveDistance() {
        device.read(port)
    }
    
    func sbrick(_ sbrick: SBrick, didReceiveSensorValue value: UInt16, for channel: SBrickChannel) {
        print("SBrickMotionSensor didReceiveSensorValue")
    }
}
