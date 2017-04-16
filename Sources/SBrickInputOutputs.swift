//
//  SBrickInputOutputs.swift
//  SmartBricks
//
//  Created by Claus Höfele on 16.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

open class SBrickMotor: Motor {
    open let device: SBrick
    open let channel: SBrickChannel
    
    init(device: SBrick, channel: SBrickChannel) {
        self.device = device
        self.channel = channel
    }
    
    open func drive(direction: MotorDirection, power: UInt8) {
        let command = SBrickRemoteControlCommand.driveCommand(channel: channel, power: power, direction: direction)
        device.write(command)
    }
    
    open func `break`() {
        let command = SBrickRemoteControlCommand.breakCommand(channel: channel)
        device.write(command)
    }
}

open class SBrickQuickDrive: InputOutput {
    open let device: SBrick
    open let channel: SBrickChannel
    
    init(device: SBrick, channel: SBrickChannel) {
        self.device = device
        self.channel = channel
    }
    
    func updateQuickDrive(channelValues: [(power: UInt8, direction: MotorDirection)]) {
        let command = SBrickQuickDriveCommand(channelValues: channelValues)
        device.write(command)
    }
}
