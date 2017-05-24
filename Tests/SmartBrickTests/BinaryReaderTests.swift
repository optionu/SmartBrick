//
//  BinaryReaderTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on 05.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBrick

class BinaryReaderTests: XCTestCase {
    func testBigEndian() {
        let bigEndianData = Data(bytes: [0x01,
                                         0x01, 0x02,
                                         0x01, 0x02, 0x03, 0x04])
        let binaryReader = BinaryReader(withData: bigEndianData, bigEndian: true)
        XCTAssertEqual(binaryReader.data, bigEndianData)
        XCTAssertTrue(binaryReader.bigEndian)

        XCTAssertEqual(binaryReader.readUInt8(), 1)
        XCTAssertEqual(binaryReader.readUInt16(), 258)
        XCTAssertEqual(binaryReader.readUInt32(), 16909060)
    }
    
    func testLittleEndian() {
        let bigEndianData = Data(bytes: [0x01,
                                         0x02, 0x01,
                                         0x04, 0x03, 0x02, 0x01])
        let binaryReader = BinaryReader(withData: bigEndianData)
        XCTAssertEqual(binaryReader.data, bigEndianData)
        XCTAssertFalse(binaryReader.bigEndian)
        
        XCTAssertEqual(binaryReader.readUInt8(), 1)
        XCTAssertEqual(binaryReader.readUInt16(), 258)
        XCTAssertEqual(binaryReader.readUInt32(), 16909060)
    }
    
    func testCanRead() {
        let data = Data(bytes: [0x01, 0x02])
        let binaryReader = BinaryReader(withData: data)
        
        XCTAssertTrue(binaryReader.canRead(numberOfBytes:0))
        XCTAssertTrue(binaryReader.canRead(numberOfBytes:1))
        XCTAssertTrue(binaryReader.canRead(numberOfBytes:2))
        XCTAssertFalse(binaryReader.canRead(numberOfBytes:3))
    }
    
    func testAdvance() {
        let data = Data(bytes: [0x01])
        let binaryReader = BinaryReader(withData: data)

        XCTAssertEqual(binaryReader.position, 0)
        XCTAssertTrue(binaryReader.canRead(numberOfBytes:1))
        binaryReader.advance(byNumberOfBytes: 1)
        XCTAssertEqual(binaryReader.position, 1)
        XCTAssertFalse(binaryReader.canRead(numberOfBytes:1))
    }

    func testReset() {
        let data = Data(bytes: [0x01])
        let binaryReader = BinaryReader(withData: data)
        
        binaryReader.advance(byNumberOfBytes: 1)
        XCTAssertEqual(binaryReader.position, 1)
        binaryReader.reset()
        XCTAssertEqual(binaryReader.position, 0)
    }
    
    func testPosition() {
        let data = Data(bytes: [0x01])
        let binaryReader = BinaryReader(withData: data)
        
        binaryReader.position(atNumberOfBytes: 1)
        XCTAssertEqual(binaryReader.position, 1)
        binaryReader.position(atNumberOfBytes: 0)
        XCTAssertEqual(binaryReader.position, 0)
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
