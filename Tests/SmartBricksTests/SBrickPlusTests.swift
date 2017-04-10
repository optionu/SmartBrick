//
//  SmartBricksTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on {TODAY}.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBricks

class SBrickPlusTests: XCTestCase {
    func testIsValidDevice() {
        let manufacturerData = Data(bytes: [0x98, 0x01,                                     // company identifier
                                            0x06, 0x00, 0x00, 0x0b, 0x00, 0x0b, 0x12,       // product type HW 11
                                            0x07, 0x02, 0xf3, 0x43, 0x3d, 0x19, 0xfd, 0xc8,
                                            0x02, 0x03, 0x00,
                                            0x05, 0x06, 0xe8, 0x4b, 0xa9, 0x5b])
        
        XCTAssertTrue(SBrickPlus.isValidDevice(manufacturerData: manufacturerData))
        XCTAssertTrue(SBrickPlus.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<2)))
        XCTAssertTrue(SBrickPlus.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<9)))
        
        // Invalid company identifier
        XCTAssertFalse(SBrickPlus.isValidDevice(manufacturerData: manufacturerData.subdata(in: 1..<3)))
        
        // Missing data in first record
        XCTAssertFalse(SBrickPlus.isValidDevice(manufacturerData: manufacturerData.subdata(in: 0..<8)))
    }
    
    func testIsValidDeviceMissingVersions() {
        let manufacturerData = Data(bytes: [0x98, 0x01,
                                            0x02, 0x00, 0x00])
        
        XCTAssertTrue(SBrick.isValidDevice(manufacturerData: manufacturerData))
    }
}

#if os(Linux)
    extension SBrickPlusTests {
        static var allTests : [(String, (SmartBricksTests) -> () throws -> Void)] {
            return [
                ("testExample", testExample),
            ]
        }
    }
#endif
