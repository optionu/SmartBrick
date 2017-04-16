//
//  SmartBricksTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on {TODAY}.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBrick

class SBrickPlusTests: XCTestCase {
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
