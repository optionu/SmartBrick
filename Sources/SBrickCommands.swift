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
        case queryADC = 0x0f
        case setUpPeriodicVoltageMeasurement = 0x2c
    }
    let commandIdentifier: CommandIdentifier
    let data: Data
    var value: Data {
        return Data(bytes: [commandIdentifier.rawValue]) + data
    }
    
    static func driveCommand(port: SBrickPort, direction: SBrickMotorDirection, power: UInt8) -> SBrickRemoteControlCommand {
        let data = Data(bytes: [port.rawValue, direction.rawValue, power])
        return SBrickRemoteControlCommand(commandIdentifier: .drive, data: data)
    }
    
    static func breakCommand(port: SBrickPort) -> SBrickRemoteControlCommand {
        return SBrickRemoteControlCommand(commandIdentifier: .break, data: Data())
    }
    
    static func quickDriveSetupCommand(port0: SBrickPort, port1: SBrickPort, port2: SBrickPort, port3: SBrickPort) -> SBrickRemoteControlCommand {
        let data = Data(bytes: [port0.rawValue, port1.rawValue, port2.rawValue, port3.rawValue])
        return SBrickRemoteControlCommand(commandIdentifier: .quickDriveSetup, data: data)
    }
    
    static func queryADCCommand(channels: Set<SBrickChannel>) -> SBrickRemoteControlCommand {
        let data = Data(channels
            .map({ $0.rawValue })
            .sorted())
        return SBrickRemoteControlCommand(commandIdentifier: .queryADC, data: data)
    }
    
    static func setUpPeriodicVoltageMeasurementCommand(channels: Set<SBrickChannel>) -> SBrickRemoteControlCommand {
        // .batteryVoltage and .temperature are always measured
        let data = Data(channels
            .filter({ $0 != .batteryVoltage && $0 != .temperature })
            .map({ $0.rawValue })
            .sorted())
        return SBrickRemoteControlCommand(commandIdentifier: .setUpPeriodicVoltageMeasurement, data: data)
    }
}

struct SBrickQuickDriveCommand: SBrickCommand {
    let portValues: [(SBrickMotorDirection, UInt8)]
    var value: Data {
        // As of Swift 3.1, can't use values.prefix(4).map (http://stackoverflow.com/questions/37931172/ambiguous-use-of-prefix-compiler-error-with-swift-3)
        // Also, Array(values.prefix(4)).map takes very long to compile thus two lines must do
        let values = portValues.prefix(4)
        let bytes = values.map { ($0 == .clockwise) ? $1 & 0xfe : $1 | 0x01 }
        return Data(bytes: bytes)
    }
}
