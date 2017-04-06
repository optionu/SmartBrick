//
//  SBrick.swift
//  SmartBricks
//
//  Created by Claus Höfele on 04/04/17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

// Enum instead?
public protocol SmartBrick {
    var identifier: UUID { get }
    var name: String? { get }
}

open class SBrick: SmartBrick {
    open var identifier: UUID
    open let name: String?

    public enum Port: Int {
        case A, B, C, D
    }
    
    public init?(identifier: UUID, name: String?, manufacturerData: Data) {
        guard SBrick.isValidDevice(manufacturerData: manufacturerData) else { return nil }
        
        self.identifier = identifier
        self.name = name
    }
    
    class func isValidDevice(manufacturerData: Data) -> Bool {
        let binaryReader = BinaryReader(withData: manufacturerData, bigEndian: true)
        
        // Company identifier
        guard binaryReader.canRead(numberOfBytes: 2),
            binaryReader.readUInt16() == 0x9801 else { return false }
        
        // Valid data records
        while (binaryReader.canRead(numberOfBytes: 1)) {
            let recordLength = Int(binaryReader.readUInt8())
            guard binaryReader.canRead(numberOfBytes: recordLength) else { return false }
            
            binaryReader.advance(byNumberOfBytes: recordLength)
        }
        
        return true
    }
    
//    open func retrieveSensorValue(port: Port)
//    open func startReceivingSensorValues(port: Port)
//    open func updateActuator(value: Double, atPort: Port)

}

open class SBrickPlus: SBrick {

}