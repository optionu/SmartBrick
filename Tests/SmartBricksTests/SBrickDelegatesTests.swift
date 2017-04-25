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
    func testRegister() {
        let delegateTestClass = DelegateTestClass()
        let delegates = SBrickDelegates()
        
        delegates.register(delegateTestClass, for: .ac1)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 1)
        XCTAssertEqual(delegates.registeredChannels, [.ac1])
    }
    
    func testUnregister() {
        let delegateTestClass = DelegateTestClass()
        let delegates = SBrickDelegates()
        
        delegates.register(delegateTestClass, for: .ac1)
        delegates.unregister(delegateTestClass)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 0)
        XCTAssertEqual(delegates.registeredChannels, [])
    }
    
    func testUnregisterDifferentDelegate() {
        let delegates = SBrickDelegates()
        
        let delegateTestClass0 = DelegateTestClass()
        delegates.register(delegateTestClass0, for: .ac1)
        let delegateTestClass1 = DelegateTestClass()
        delegates.register(delegateTestClass1, for: .ac1)

        delegates.unregister(delegateTestClass0)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 1)
        XCTAssertEqual(delegates.registeredChannels, [.ac1])
    }
    
    func testUnregisterSameDelegateMultipleChannels() {
        let delegateTestClass = DelegateTestClass()
        let delegates = SBrickDelegates()
        
        delegates.register(delegateTestClass, for: .ac1)
        delegates.register(delegateTestClass, for: .bc1)
        delegates.unregister(delegateTestClass)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 0)
        XCTAssertEqual(delegates.registeredChannels, [])
    }
    
    // Register same channel twice for delegate
    // Register same channel for two different delegates
    // Register same delegate with different channels
    // Has registered for new channel
    
    // Unregister one, but keep other
    // Automatic unregistration
}
