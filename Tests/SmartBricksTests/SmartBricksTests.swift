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
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //// XCTAssertEqual(SmartBricks().text, "Hello, World!")
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
