//
//  MulticastDelegateTests.swift
//  SmartBrick
//
//  Created by Claus Höfele on 19.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBrick

protocol TestDelegate {
    func doThis()
}

class DelegateTestClass: TestDelegate {
    func doThis() {}
}

class MulticastDelegateTests: XCTestCase {
    func testMulticast() {
        let multicastDelegate = MulticastDelegate<TestDelegate>()
        
        let delegateTestClass0 = DelegateTestClass()
        multicastDelegate.append(delegateTestClass0)
        XCTAssertEqual(multicastDelegate.count, 1)
        XCTAssertTrue(multicastDelegate.contains(delegateTestClass0))
        
        let delegateTestClass1 = DelegateTestClass()
        multicastDelegate.append(delegateTestClass1)
        XCTAssertEqual(multicastDelegate.count, 2)
        XCTAssertTrue(multicastDelegate.contains(delegateTestClass1))
        
        var delegatesCalled = 0
        multicastDelegate.invoke { delegate in
            delegate.doThis()
            delegatesCalled += 1
        }
        
        XCTAssertEqual(delegatesCalled, 2)
    }
    
    func testWeak() {
        let multicastDelegate = MulticastDelegate<TestDelegate>()
        
        autoreleasepool {
            let delegateTestClass = DelegateTestClass()
            multicastDelegate.append(delegateTestClass)
        }

        XCTAssertEqual(multicastDelegate.count, 0)
    }
    
    func testSet() {
        let multicastDelegate = MulticastDelegate<TestDelegate>()
        let delegateTestClass = DelegateTestClass()
        multicastDelegate.append(delegateTestClass)
        multicastDelegate.append(delegateTestClass)
        
        XCTAssertEqual(multicastDelegate.count, 1)
    }
    
    func testRemove() {
        let multicastDelegate = MulticastDelegate<TestDelegate>()
        let delegateTestClass = DelegateTestClass()
        multicastDelegate.append(delegateTestClass)
        multicastDelegate.remove(delegateTestClass)
        
        XCTAssertEqual(multicastDelegate.count, 0)
    }
}
