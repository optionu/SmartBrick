//
//  SBrickCommandsTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on 16.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBricks

class SBrickCommandsTests: XCTestCase {
    func testRemoteControlCommand() {
        let data = Data(bytes: [0x01, 0x02, 0x03])
        let command = SBrickRemoteControlCommand(commandIdentifier: .drive, data: data)
        XCTAssertEqual(command.commandIdentifier, .drive)
        XCTAssertEqual(command.data, data)
    }
    
    func testRemoteControlCommandDrive() {
        let command: SBrickCommand = SBrickRemoteControlCommand.driveCommand(channel: .b, direction: .counterclockwise, power: 3)
        XCTAssertEqual(command.value, Data(bytes: [0x01, 0x02, 0x01, 0x03]))
    }
    
    func testRemoteControlCommandBreak() {
        let command: SBrickCommand = SBrickRemoteControlCommand.breakCommand(channel: .a)
        XCTAssertEqual(command.value, Data(bytes: [0x00]))
    }
    
    func testQuickDriveCommand() {
        let channelValues: [(MotorDirection, UInt8)] = [(.clockwise, 100), (.counterclockwise, 123)]
        let command = SBrickQuickDriveCommand(channelValues: channelValues)
        XCTAssertEqual(command.channelValues[0].0, channelValues[0].0)
        XCTAssertEqual(command.channelValues[0].1, channelValues[0].1)
        XCTAssertEqual(command.channelValues[1].0, channelValues[1].0)
        XCTAssertEqual(command.channelValues[1].1, channelValues[1].1)
    }
    
    func testQuickDriveCommandValue() {
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: [(.clockwise, 0)]).value, Data(bytes: [0x00]))
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: [(.clockwise, 16)]).value, Data(bytes: [0x10]))
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: [(.clockwise, 255)]).value, Data(bytes: [0xfe]))
        
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: [(.counterclockwise, 0)]).value, Data(bytes: [0x01]))
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: [(.counterclockwise, 16)]).value, Data(bytes: [0x11]))
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: [(.counterclockwise, 255)]).value, Data(bytes: [0xff]))
        
        let channelValue: (MotorDirection, UInt8) = (.clockwise, 100)
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: Array(repeating: channelValue, count: 0)).value.count, 0)
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: Array(repeating: channelValue, count: 1)).value.count, 1)
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: Array(repeating: channelValue, count: 4)).value.count, 4)
        XCTAssertEqual(SBrickQuickDriveCommand(channelValues: Array(repeating: channelValue, count: 5)).value.count, 4)
    }
}

#if os(Linux)
    extension SBrickInputOuputsTests {
        static var allTests : [(String, (SmartBricksTests) -> () throws -> Void)] {
            return [
                ("testExample", testExample),
            ]
        }
    }
#endif
