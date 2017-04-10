//
//  BinaryReader.swift
//  SmartBricks
//
//  Created by Claus Höfele on 05.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

class BinaryReader {
    private(set) var position = 0
    let data: Data
    let bigEndian: Bool
    
    init(withData data: Data, bigEndian: Bool = false) {
        self.data = data
        self.bigEndian = bigEndian
    }
    
    func canRead(numberOfBytes bytes: Int) -> Bool {
        return position + bytes <= data.count
    }
    
    func reset() {
        position = 0
    }
    
    func position(atNumberOfBytes bytes: Int) {
        precondition(position <= data.count)
        
        position = bytes
    }
    
    func advance(byNumberOfBytes bytes: Int) {
        precondition(canRead(numberOfBytes: bytes))
        
        position += bytes
    }
    
    func readUInt8() -> UInt8 {
        return readInteger()
    }
    
    func readUInt16() -> UInt16 {
        return bigEndian ? UInt16(bigEndian: readInteger()) : UInt16(littleEndian: readInteger())
    }
    
    func readUInt32() -> UInt32 {
        return bigEndian ? UInt32(bigEndian: readInteger()) : UInt32(littleEndian: readInteger())
    }

    private func readInteger<T: Integer>() -> T {
        precondition(canRead(numberOfBytes: MemoryLayout<T>.size))
        
        let value = data.withUnsafeBytes({(bytePointer: UnsafePointer<UInt8>) in
            bytePointer.advanced(by: position).withMemoryRebound(to: T.self, capacity: MemoryLayout<T>.size) { pointer in
                return pointer.pointee
            }
        })
        position += MemoryLayout<T>.size
        
        return value
    }
}
