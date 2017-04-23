//
//  SBrickControllerTests.swift
//  SmartBrick
//
//  Created by Claus Höfele on 23.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBrick

class SBrickControllerTests: XCTestCase {
    func testSplitValueChannel() {
        XCTAssertEqual(SBrickController.splitValue(0x0000)?.channel, .ac1)
        XCTAssertEqual(SBrickController.splitValue(0x0001)?.channel, .ac2)
        XCTAssertEqual(SBrickController.splitValue(0x0008)?.channel, .batteryVoltage)
        XCTAssertEqual(SBrickController.splitValue(0x0009)?.channel, .temperature)
    }
    
    func testSplitValueChannelIndependent() {
        XCTAssertEqual(SBrickController.splitValue(0x0003)?.channel, .bc2)
        XCTAssertEqual(SBrickController.splitValue(0xfff3)?.channel, .bc2)
        XCTAssertEqual(SBrickController.splitValue(0x1233)?.channel, .bc2)
    }
    
    func testSplitValueChannelInvalid() {
        XCTAssertNil(SBrickController.splitValue(0x000f))
    }
    
    func testSplitValueValue() {
        XCTAssertEqual(SBrickController.splitValue(0x0000)?.adc, 0x000)
        XCTAssertEqual(SBrickController.splitValue(0xfff0)?.adc, 0xfff)
        XCTAssertEqual(SBrickController.splitValue(0x1230)?.adc, 0x123)
    }
    
    func testSplitValueValueIndependent() {
        XCTAssertEqual(SBrickController.splitValue(0x1230)?.adc, 0x123)
        XCTAssertEqual(SBrickController.splitValue(0x1231)?.adc, 0x123)
        XCTAssertEqual(SBrickController.splitValue(0x1239)?.adc, 0x123)
    }
    
    func testReadValues() {
        XCTAssertEqual(SBrickController.readValues(Data()), [])
        XCTAssertEqual(SBrickController.readValues(Data(bytes: [0x12, 0xf0])), [0xf012])
        XCTAssertEqual(SBrickController.readValues(Data(bytes: [0x12, 0xf0, 0xff])), [0xf012])
        XCTAssertEqual(SBrickController.readValues(Data(bytes: [0x12, 0xf0, 0xff, 0x00])), [0xf012, 0x00ff])
    }
}
