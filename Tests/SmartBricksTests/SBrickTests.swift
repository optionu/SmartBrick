//
//  SmartBricksTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on {TODAY}.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBricks

class SBrickTests: XCTestCase {
    func testIsValidDeviceSBrick() {
        let hardwareVersion: UInt8 = 10
        let manufacturerData = Data(bytes: [0x98, 0x01,                                     // company identifier
                                            0x06, 0x00, 0x00, hardwareVersion, 0x00, 0x0b, 0x12,
                                            0x07, 0x02, 0xf3, 0x43, 0x3d, 0x19, 0xfd, 0xc8,
                                            0x02, 0x03, 0x00,
                                            0x05, 0x06, 0xe8, 0x4b, 0xa9, 0x5b])
        
        XCTAssertTrue(SBrick.isValidDevice(manufacturerData: manufacturerData, testForSBrickPlus: false))
        XCTAssertTrue(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<2), testForSBrickPlus: false))
        XCTAssertTrue(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<9), testForSBrickPlus: false))
        
        // Invalid company identifier
        XCTAssertFalse(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 1..<3), testForSBrickPlus: false))
        
        // Missing data in first record
        XCTAssertFalse(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<8), testForSBrickPlus: false))
    }

    func testIsValidDeviceSBrickPlus() {
        let hardwareVersion: UInt8 = 11
        let manufacturerData = Data(bytes: [0x98, 0x01,                                     // company identifier
                                            0x06, 0x00, 0x00, hardwareVersion, 0x00, 0x0b, 0x12,
                                            0x07, 0x02, 0xf3, 0x43, 0x3d, 0x19, 0xfd, 0xc8,
                                            0x02, 0x03, 0x00,
                                            0x05, 0x06, 0xe8, 0x4b, 0xa9, 0x5b])

        XCTAssertTrue(SBrick.isValidDevice(manufacturerData: manufacturerData, testForSBrickPlus: true))
        XCTAssertFalse(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<2), testForSBrickPlus: true))
        XCTAssertTrue(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<9), testForSBrickPlus: true))

        // Invalid company identifier
        XCTAssertFalse(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 1..<3), testForSBrickPlus: true))

        // Missing data in first record
        XCTAssertFalse(SBrick.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<8), testForSBrickPlus: true))
    }

    func testIsValidDeviceMissingVersions() {
        let manufacturerData = Data(bytes: [0x98, 0x01,
                                            0x02, 0x00, 0x00])
        
        XCTAssertTrue(SBrick.isValidDevice(manufacturerData: manufacturerData, testForSBrickPlus: false))
        XCTAssertFalse(SBrick.isValidDevice(manufacturerData: manufacturerData, testForSBrickPlus: true))
    }
}

#if os(Linux)
extension SBrickTests {
    static var allTests : [(String, (SmartBricksTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
#endif
