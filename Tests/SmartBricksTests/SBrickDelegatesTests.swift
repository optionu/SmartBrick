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
    var delegates: SBrickDelegates!
    
    override func setUp() {
        super.setUp()
        
        delegates = SBrickDelegates()
    }
    
    func testRegister() {
        let delegateTestClass = DelegateTestClass()
        
        delegates.register(delegateTestClass, for: .ac1)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 1)
        XCTAssertEqual(delegates.registeredChannels, [.ac1])
    }
    
    func testRegisterSameDelegateSameChannelTwice() {
        let delegateTestClass = DelegateTestClass()
        
        delegates.register(delegateTestClass, for: .ac1)
        delegates.register(delegateTestClass, for: .ac1)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 1)
        XCTAssertEqual(delegates.registeredChannels, [.ac1])
    }
    
    func testRegisterMultipleDelegatesSameChannel() {
        let delegateTestClass0 = DelegateTestClass()
        delegates.register(delegateTestClass0, for: .ac1)
        let delegateTestClass1 = DelegateTestClass()
        delegates.register(delegateTestClass1, for: .ac1)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 2)
        XCTAssertEqual(delegates.registeredChannels, [.ac1])
    }
    
    func testRegisterSameDelegateMutlipleChannels() {
        let delegateTestClass = DelegateTestClass()
        
        delegates.register(delegateTestClass, for: .cc1)
        delegates.register(delegateTestClass, for: .bc2)
        XCTAssertEqual(delegates.delegates[.cc1]?.count, 1)
        XCTAssertEqual(delegates.delegates[.bc2]?.count, 1)
        XCTAssertEqual(delegates.registeredChannels, [.cc1, .bc2])
        XCTAssertEqual(delegates.registeredChannels, [.bc2, .cc1])
    }
    
    func testRegisteredNewChannels() {
        let delegateTestClass0 = DelegateTestClass()
        let delegateTestClass1 = DelegateTestClass()
        
        XCTAssertTrue(delegates.register(delegateTestClass0, for: .ac1))
        XCTAssertFalse(delegates.register(delegateTestClass0, for: .ac1))
        XCTAssertTrue(delegates.register(delegateTestClass0, for: .dc1))
        
        XCTAssertFalse(delegates.register(delegateTestClass1, for: .ac1))
        XCTAssertTrue(delegates.register(delegateTestClass1, for: .bc2))
    }
    
    func testUnregister() {
        let delegateTestClass = DelegateTestClass()
        delegates.register(delegateTestClass, for: .ac1)
        
        delegates.unregister(delegateTestClass)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 0)
        XCTAssertEqual(delegates.registeredChannels, [])
    }
    
    func testUnregisterAutomatic() {
        autoreleasepool {
            let delegateTestClass = DelegateTestClass()
            delegates.register(delegateTestClass, for: .ac1)
        }
        
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 0)
        XCTAssertEqual(delegates.registeredChannels, [])
    }
    
    func testUnregisterDifferentDelegate() {
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
        delegates.register(delegateTestClass, for: .ac1)
        delegates.register(delegateTestClass, for: .bc1)
        
        delegates.unregister(delegateTestClass)
        XCTAssertEqual(delegates.delegates[.ac1]?.count, 0)
        XCTAssertEqual(delegates.registeredChannels, [])
    }
}
