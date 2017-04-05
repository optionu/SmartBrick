//
//  BinaryReader.swift
//  SmartBricks
//
//  Created by Claus Höfele on 05.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

class BinaryReader {
    var position = 0
    let data: Data
    let bigEndian: Bool
    
    init(withData data: Data, bigEndian: Bool = false) {
        self.data = data
        self.bigEndian = bigEndian
    }
    
    func readUInt8() -> UInt8 {
        let value: UInt8 = readInteger(fromData: data, start: position)
        position += MemoryLayout<UInt8>.size
        
        return value
    }
    
    func readUInt16() -> UInt16 {
        let value: UInt16 = readInteger(fromData: data, start: position)
        position += MemoryLayout<UInt16>.size
        
        return bigEndian ? UInt16(bigEndian: value) : UInt16(littleEndian: value)
    }
    
    func readUInt32() -> UInt32 {
        let value: UInt32 = readInteger(fromData: data, start: position)
        position += MemoryLayout<UInt32>.size
        
        return bigEndian ? UInt32(bigEndian: value) : UInt32(littleEndian: value)
    }

    private func readInteger<T: Integer>(fromData data: Data, start: Int) -> T {
        return data.withUnsafeBytes({(bytePointer: UnsafePointer<UInt8>) in
            bytePointer.advanced(by: start).withMemoryRebound(to: T.self, capacity: MemoryLayout<T>.size) { pointer in
                return pointer.pointee
            }
        })
    }
}