//
//  SBrickCommandsTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on 16.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBrick

class SBrickCommandsTests: XCTestCase {
    func testRemoteControlCommand() {
        let data = Data(bytes: [0x01, 0x02, 0x03])
        let command = SBrickRemoteControlCommand(commandIdentifier: .drive, data: data)
        XCTAssertEqual(command.commandIdentifier, .drive)
        XCTAssertEqual(command.data, data)
    }
    
    func testRemoteControlCommandDrive() {
        let command: SBrickCommand = SBrickRemoteControlCommand.driveCommand(port: .b, direction: .counterclockwise, power: 3)
        XCTAssertEqual(command.value, Data(bytes: [0x01, 0x02, 0x01, 0x03]))
    }
    
    func testRemoteControlCommandBreak() {
        let command: SBrickCommand = SBrickRemoteControlCommand.breakCommand(port: .a)
        XCTAssertEqual(command.value, Data(bytes: [0x00]))
    }
    
    func testRemoteControlCommandQuickDriveSetup() {
        let command: SBrickCommand = SBrickRemoteControlCommand.quickDriveSetupCommand(port0: .a, port1: .c, port2: .b, port3: .d)
        XCTAssertEqual(command.value, Data(bytes: [0x0b, 0x00, 0x01, 0x02, 0x03]))
    }
    
    func testQueryADCCommand() {
        let command: SBrickCommand = SBrickRemoteControlCommand.queryADCCommand(channels: [.ac1, .ac2, .cc1, .batteryVoltage])
        XCTAssertEqual(command.value, Data(bytes: [0x0f, 0x00, 0x01, 0x02, 0x08]))
    }
    
    func testSetUpPeriodicVoltageMeasurementCommand() {
        let command: SBrickCommand = SBrickRemoteControlCommand.setUpPeriodicVoltageMeasurementCommand(channels: [.ac1, .ac2, .cc1, .batteryVoltage])
        XCTAssertEqual(command.value, Data(bytes: [0x2c, 0x00, 0x01, 0x02]))
    }
    
    func testQuickDriveCommand() {
        let portValues: [(SBrickMotorDirection, UInt8)] = [(.clockwise, 100), (.counterclockwise, 123)]
        let command = SBrickQuickDriveCommand(portValues: portValues)
        XCTAssertEqual(command.portValues[0].0, portValues[0].0)
        XCTAssertEqual(command.portValues[0].1, portValues[0].1)
        XCTAssertEqual(command.portValues[1].0, portValues[1].0)
        XCTAssertEqual(command.portValues[1].1, portValues[1].1)
    }
    
    func testQuickDriveCommandValue() {
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: [(.clockwise, 0)]).value, Data(bytes: [0x00]))
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: [(.clockwise, 16)]).value, Data(bytes: [0x10]))
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: [(.clockwise, 255)]).value, Data(bytes: [0xfe]))
        
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: [(.counterclockwise, 0)]).value, Data(bytes: [0x01]))
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: [(.counterclockwise, 16)]).value, Data(bytes: [0x11]))
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: [(.counterclockwise, 255)]).value, Data(bytes: [0xff]))
        
        let portValue: (SBrickMotorDirection, UInt8) = (.clockwise, 100)
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: Array(repeating: portValue, count: 0)).value.count, 0)
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: Array(repeating: portValue, count: 1)).value.count, 1)
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: Array(repeating: portValue, count: 4)).value.count, 4)
        XCTAssertEqual(SBrickQuickDriveCommand(portValues: Array(repeating: portValue, count: 5)).value.count, 4)
    }
}
