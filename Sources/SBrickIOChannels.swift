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

public enum SBrickMotorDirection: UInt8 {
    // Viewed from the drive end
    case clockwise = 0x00, counterclockwise = 0x01
}

open class SBrickMotor: SBrickInputOutput, IOChannel {
    open func drive(direction: SBrickMotorDirection, power: UInt8) {
        let command = SBrickRemoteControlCommand.driveCommand(channel: channel, direction: direction, power: power)
        device.write(command)
    }
    
    open func `break`() {
        let command = SBrickRemoteControlCommand.breakCommand(channel: channel)
        device.write(command)
    }
}

open class SBrickQuickDrive: SBrickInputOutput, IOChannel {
    // Default order: 0, 1, 2, 3/A, C, B, D
    open func changeChannelMapping(channel0: SBrickChannel, channel1: SBrickChannel, channel2: SBrickChannel, channel3: SBrickChannel) {
        let command = SBrickRemoteControlCommand.quickDriveSetupCommand(channel0: channel0, channel1: channel1, channel2: channel2, channel3: channel3)
        device.write(command)
    }
    
    open func drive(channelValues: [(direction: SBrickMotorDirection, power: UInt8)]) {
        let command = SBrickQuickDriveCommand(channelValues: channelValues)
        device.write(command)
    }
}

open class SBrickMotionSensor: SBrickInputOutput, IOChannel {
    open func retrieveDistance() {
        device.read(channel)
    }
}
