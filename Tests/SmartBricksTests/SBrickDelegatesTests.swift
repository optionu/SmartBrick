//
//  SBrickDelegatesTests.swift
//  SmartBrick
//
//  Created by Claus Höfele on 23.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBrick

private class DelegateTestClass: SBrickDelegate {
    func sbrick(_ sbrick: SBrick, didReceiveSensorValue value: UInt16, for channel: SBrickChannel) {
    }
}

class SBrickDelegatesTests: XCTestCase {
    func testAppend() {
        let delegateTestClass = DelegateTestClass()
        let delegates = SBrickDelegates()
        
        delegates.register(delegateTestClass, for: .ac1)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 1)
        XCTAssertEqual(delegates.registeredChannels, [.ac1])
    }
    
    // Register same channel twice for delegate
    // Register same channel for two different delegates
    // Register same delegate with different channels
    
    // Unregister
    // Unregister for all channels
    // Automatic unregistration
}
