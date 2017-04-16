//
//  SBrickRemoteControlCommand.swift
//  SmartBricks
//
//  Created by Claus Höfele on 15.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

protocol SBrickCommand {
    var value: Data { get }
}

struct SBrickRemoteControlCommand: SBrickCommand {
    enum CommandIdentifier: UInt8 {
        case `break` = 0x00
        case drive = 0x01
        case quickDriveSetup = 0x0b
    }
    let commandIdentifier: CommandIdentifier
    let data: Data
    var value: Data {
        return Data(bytes: [commandIdentifier.rawValue]) + data
    }
    
    static func driveCommand(channel: SBrickChannel, direction: MotorDirection, power: UInt8) -> SBrickRemoteControlCommand {
        let data = Data(bytes: [channel.rawValue, direction.rawValue, power])
        return SBrickRemoteControlCommand(commandIdentifier: .drive, data: data)
    }
    
    static func breakCommand(channel: SBrickChannel) -> SBrickRemoteControlCommand {
        return SBrickRemoteControlCommand(commandIdentifier: .break, data: Data())
    }
    
    static func quickDriveSetupCommand(channel0: SBrickChannel, channel1: SBrickChannel, channel2: SBrickChannel, channel3: SBrickChannel) -> SBrickRemoteControlCommand {
        let data = Data(bytes: [channel0.rawValue, channel1.rawValue, channel2.rawValue, channel3.rawValue])
        return SBrickRemoteControlCommand(commandIdentifier: .quickDriveSetup, data: data)
    }
}

struct SBrickQuickDriveCommand: SBrickCommand {
    let channelValues: [(MotorDirection, UInt8)]
    var value: Data {
        // As of Swift 3.1, can't use values.prefix(4).map (http://stackoverflow.com/questions/37931172/ambiguous-use-of-prefix-compiler-error-with-swift-3)
        // Also, Array(values.prefix(4)).map takes very long to compile thus two lines must do
        let values = channelValues.prefix(4)
        let bytes = values.map { ($0 == .clockwise) ? $1 & 0xfe : $1 | 0x01 }
        return Data(bytes: bytes)
    }
}
