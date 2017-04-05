//
//  SmartBricksTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on {TODAY}.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import XCTest
import SmartBricks

class SmartBricksTests: XCTestCase {
    func testExample() {
//        let smartBrickManager = SmartBrickManager()
//        smartBrickManager.scanForDevices()
//        let e = expectation(description: "description")
//        waitForExpectations(timeout: 10, handler: nil)
//        
//        // Advertisement data
//        let data = Data(bytes: [0x98, 0x01,
//                                0x06, 0x00, 0x00, 0x0b, 0x00, 0x0b, 0x12,
//                                0x07, 0x02, 0xf3, 0x43, 0x3d, 0x19, 0xfd, 0xc8,
//                                0x02, 0x03, 0x00,
//                                0x05, 0x06, 0xe8, 0x4b, 0xa9, 0x5b])
    }
}

#if os(Linux)
extension SmartBricksTests {
    static var allTests : [(String, (SmartBricksTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
#endif
