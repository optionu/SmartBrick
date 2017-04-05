//
//  BinaryReaderTests.swift
//  SmartBricks
//
//  Created by Claus Höfele on 05.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import XCTest
@testable import SmartBricks

class BinaryReaderTests: XCTestCase {
    func testBigEndian() {
        let bigEndianData = Data(bytes: [0x01,
                                         0x01, 0x02,
                                         0x01, 0x02, 0x03, 0x04])
        let binaryReader = BinaryReader(withData: bigEndianData, bigEndian: true)

        XCTAssertEqual(binaryReader.readUInt8(), 1)
        XCTAssertEqual(binaryReader.readUInt16(), 258)
        XCTAssertEqual(binaryReader.readUInt32(), 16909060)
    }
    
    func testLittleEndian() {
        let bigEndianData = Data(bytes: [0x01,
                                         0x02, 0x01,
                                         0x04, 0x03, 0x02, 0x01])
        let binaryReader = BinaryReader(withData: bigEndianData, bigEndian: false)
        
        XCTAssertEqual(binaryReader.readUInt8(), 1)
        XCTAssertEqual(binaryReader.readUInt16(), 258)
        XCTAssertEqual(binaryReader.readUInt32(), 16909060)
    }
    
    // canReadNumberOfBytes
    // skipNumberOfBytes
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
