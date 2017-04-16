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
    open let channel: SBrickChannel
    
    init(device: SBrick, channel: SBrickChannel) {
        self.device = device
        self.channel = channel
    }
}

open class SBrickMotor: SBrickInputOutput, Motor {
    open func drive(direction: MotorDirection, power: UInt8) {
        let command = SBrickRemoteControlCommand.driveCommand(channel: channel, direction: direction, power: power)
        device.write(command)
    }
    
    open func `break`() {
        let command = SBrickRemoteControlCommand.breakCommand(channel: channel)
        device.write(command)
    }
}

open class SBrickQuickDrive: SBrickInputOutput, InputOutput {
    // Default order: 0, 1, 2, 3/A, C, B, D
    open func changeChannelMapping(channel0: SBrickChannel, channel1: SBrickChannel, channel2: SBrickChannel, channel3: SBrickChannel) {
        let command = SBrickRemoteControlCommand.quickDriveSetupCommand(channel0: channel0, channel1: channel1, channel2: channel2, channel3: channel3)
        device.write(command)
    }
    
    open func drive(channelValues: [(direction: MotorDirection, power: UInt8)]) {
        let command = SBrickQuickDriveCommand(channelValues: channelValues)
        device.write(command)
    }
}
