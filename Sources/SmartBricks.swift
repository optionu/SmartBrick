//
//  SBrick.swift
//  SmartBricks
//
//  Created by Claus Höfele on 04/04/17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

private let remoteControlService = CBUUID(string:"4dc591b0-857c-41de-b5f1-15abda665b0c")
private let services = [remoteControlService]
private let quickDriveCharacteristic = CBUUID(string: "489a6ae0-c1ab-4c9c-bdb2-11d373c1b7fb")
private let remoteControlCommandsCharacteristic = CBUUID(string: "02b8cbcc-0e25-4bda-8790-a15f53e6010f")
private let remoteControlCharacteristics = [quickDriveCharacteristic, remoteControlCommandsCharacteristic]

// Enum instead?
public protocol SmartBrick {
    var peripheral: CBPeripheral { get }
    
    func prepareConnection(completionHandler: @escaping (() -> Void))
}

open class SBrick: NSObject, SmartBrick, CBPeripheralDelegate {
    public let peripheral: CBPeripheral
    private var completionBlock: (() -> Void)?
    
    public enum Port: Int {
        case A, B, C, D
    }
    
    public init?(peripheral: CBPeripheral, manufacturerData: Data) {
        guard SBrick.isValidDevice(manufacturerData: manufacturerData) else { return nil }
        
        self.peripheral = peripheral
        
        super.init()
        
        peripheral.delegate = self
    }
    
    deinit {
        print("deinit")
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
    
    public func prepareConnection(completionHandler: @escaping (() -> Void)) {
        assert(peripheral.state == .connected)
        print("discoverServices \(services)")
        
        completionBlock = completionHandler
        peripheral.discoverServices(nil)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices \(String(describing: error))")
        
        if error == nil, let services = peripheral.services {
            for service in services {
                switch service.uuid {
                case remoteControlService:
                    print("discoverCharacteristics")
                    peripheral.discoverCharacteristics(remoteControlCharacteristics, for: service)
                default:
                    // This is a service we don't care about. Ignore it.
                    continue
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristics \(String(describing: error))")
        
        completionBlock?()
    }
    
//    open func retrieveSensorValue(port: Port)
//    open func startReceivingSensorValues(port: Port)
//    open func updateActuator(value: Double, atPort: Port)

}

open class SBrickPlus: SBrick {

}
