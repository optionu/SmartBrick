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
    func testConvertADCValueChannel() {
        XCTAssertEqual(SBrickController.splitADCRawValue(0x0000)?.channel, .ac1)
        XCTAssertEqual(SBrickController.splitADCRawValue(0x0001)?.channel, .ac2)
        XCTAssertEqual(SBrickController.splitADCRawValue(0x0008)?.channel, .batteryVoltage)
        XCTAssertEqual(SBrickController.splitADCRawValue(0x0009)?.channel, .temperature)
    }
    
    func testConvertADCValueChannelIndependent() {
        XCTAssertEqual(SBrickController.splitADCRawValue(0x0003)?.channel, .bc2)
        XCTAssertEqual(SBrickController.splitADCRawValue(0xfff3)?.channel, .bc2)
        XCTAssertEqual(SBrickController.splitADCRawValue(0x1233)?.channel, .bc2)
    }
    
    func testConvertADCValueChannelInvalid() {
        XCTAssertNil(SBrickController.splitADCRawValue(0x000f))
    }
    
    func testConvertADCValueValue() {
        XCTAssertEqual(SBrickController.splitADCRawValue(0x0000)?.value, 0x000)
        XCTAssertEqual(SBrickController.splitADCRawValue(0xfff0)?.value, 0xfff)
        XCTAssertEqual(SBrickController.splitADCRawValue(0x1230)?.value, 0x123)
    }
    
    func testConvertADCValueValueIndependent() {
        XCTAssertEqual(SBrickController.splitADCRawValue(0x1230)?.value, 0x123)
        XCTAssertEqual(SBrickController.splitADCRawValue(0x1231)?.value, 0x123)
        XCTAssertEqual(SBrickController.splitADCRawValue(0x1239)?.value, 0x123)
    }
}
