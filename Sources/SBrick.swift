//
//  SBricks.swift
//  SmartBricks
//
//  Created by Claus Höfele on 10.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

private let remoteControlServiceUUID = CBUUID(string:"4dc591b0-857c-41de-b5f1-15abda665b0c")
private let servicesUUIDs = [remoteControlServiceUUID]
private let quickDriveCharacteristicUUID = CBUUID(string: "489a6ae0-c1ab-4c9c-bdb2-11d373c1b7fb")
private let remoteControlCommandsCharacteristicUUID = CBUUID(string: "02b8cbcc-0e25-4bda-8790-a15f53e6010f")
private let remoteControlCharacteristicUUIDs = [quickDriveCharacteristicUUID, remoteControlCommandsCharacteristicUUID]

open class SBrick: NSObject, SmartBrick, CBPeripheralDelegate {
    public let peripheral: CBPeripheral
    private var completionBlock: (() -> Void)?
    var remoteControlCommandsCharacteristic: CBCharacteristic?
    var quickDriveCharacteristic: CBCharacteristic?
    
    public convenience init?(peripheral: CBPeripheral, manufacturerData: Data) {
        self.init(peripheral: peripheral, manufacturerData: manufacturerData, shouldBePlus: false)
    }
    
    init?(peripheral: CBPeripheral, manufacturerData: Data, shouldBePlus: Bool) {
        guard SBrick.isValidDevice(manufacturerData: manufacturerData, testForSBrickPlus: shouldBePlus) else { return nil }
        
        self.peripheral = peripheral
        
        super.init()
        
        peripheral.delegate = self
    }
    
    class func isValidDevice(manufacturerData: Data, testForSBrickPlus: Bool) -> Bool {
        let binaryReader = BinaryReader(withData: manufacturerData, bigEndian: true)
        
        // Check company identifier
        guard binaryReader.canRead(numberOfBytes: 2),
            binaryReader.readUInt16() == 0x9801 else { return false }

        var isSBrickPlus = false

        // Check for valid data records
        while (binaryReader.canRead(numberOfBytes: 1)) {
            let recordLength = Int(binaryReader.readUInt8())
            guard binaryReader.canRead(numberOfBytes: recordLength) else { return false }
            
            let position = binaryReader.position
            
            // Check record identifier
            if recordLength == 6 && binaryReader.readUInt8() >= 0 && binaryReader.readUInt8() == 0x00 {
                // HW 11+ means it's an SBrick Plus
                isSBrickPlus = binaryReader.readUInt8() >= 11
            }
            
            binaryReader.position(atNumberOfBytes: position)
            binaryReader.advance(byNumberOfBytes: recordLength)
        }

        // Distinguish between SBrick and SBrick Plus
        if testForSBrickPlus && !isSBrickPlus {
            return false
        } else if !testForSBrickPlus && isSBrickPlus {
            return false
        } else {
            return true
        }
    }

    public func prepareConnection(completionHandler: @escaping (() -> Void)) {
        assert(peripheral.state == .connected)
        print("discoverServices \(servicesUUIDs)")
        
        completionBlock = completionHandler
        peripheral.discoverServices(nil)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices \(String(describing: error))")
        
        if error == nil, let services = peripheral.services {
            for service in services {
                switch service.uuid {
                case remoteControlServiceUUID:
                    print("discoverCharacteristics")
                    peripheral.discoverCharacteristics(remoteControlCharacteristicUUIDs, for: service)
                default:
                    // This is a service we don't care about. Ignore it.
                    continue
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristics \(String(describing: error))")
        
        for characteristic in service.characteristics ?? [] {
            switch characteristic.uuid {
            case remoteControlCommandsCharacteristicUUID:
                remoteControlCommandsCharacteristic = characteristic
            case quickDriveCharacteristicUUID:
                quickDriveCharacteristic = characteristic
            default:
                assert(false, "Unknown characteristic")
            }
        }
        
        if remoteControlCommandsCharacteristic != nil && quickDriveCharacteristic != nil {
            completionBlock?()
        }
    }
    
    //    open func retrieveSensorValue(for channel: Channel)
    //    open func startReceivingSensorValues(for channel: Channel)
    //    open func updateActuator(for channel: Channel, with value: UInt8)
}

extension SBrick {
    // Letters are numbered according to SBrick app; numbers match channels
    // --o--
    // aa bb
    // cc dd
    // --|--
    public enum Channel: UInt8 {
        case a = 0x00, b = 0x02, c = 0x01, d = 0x03
    }
    
    // Viewed from the drive end
    public enum Direction: UInt8 {
        case clockwise = 0x00, counterclockwise = 0x01
    }

    // Min power for motor is 110
    open func updateDrive(channel: Channel, power: UInt8, direction: Direction) {
        if let remoteControlCommandsCharacteristic = remoteControlCommandsCharacteristic {
            let data = Data(bytes: [0x01, channel.rawValue, direction.rawValue, power])
            peripheral.writeValue(data, for: remoteControlCommandsCharacteristic, type: .withoutResponse)
        }
    }
    
    open func updateBreak(channel: Channel) {
        if let remoteControlCommandsCharacteristic = remoteControlCommandsCharacteristic {
            let data = Data(bytes: [0x00, channel.rawValue])
            peripheral.writeValue(data, for: remoteControlCommandsCharacteristic, type: .withoutResponse)
        }
    }
}

extension SBrick {
    open func updateQuickDrive(power0: UInt8, direction0: Direction) {
        if let quickDriveCharacteristic = quickDriveCharacteristic {
            let data = Data(bytes: [power0, power0, power0, power0]) // A, C, B, D
            peripheral.writeValue(data, for: quickDriveCharacteristic, type: .withoutResponse)
        }
    }
}
