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
        print("didDiscoverServices error: \(String(describing: error))")
        
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
        print("didDiscoverCharacteristics error: \(String(describing: error))")
        
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
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didWriteValue value: \(String(describing: characteristic.value)) error: \(String(describing: error))")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor value: \(String(describing: characteristic.value)) error: \(String(describing: error))")
        
        if let value = characteristic.value {
            let binaryReader = BinaryReader(withData: value, bigEndian: false)
            let adc0 = binaryReader.readUInt16()
            let adc1 = binaryReader.readUInt16()
            let adc2 = binaryReader.readUInt16()
            let adc3 = binaryReader.readUInt16()
            let voltage = Double(adc2) * 0.83875 / 2047.0;
            let voltagec = Double(adc2 & 0xfff0) * 0.83875 / 2047.0;
            let temperature = Double(adc3) / 118.85795 - 160
            let temperaturec = Double(adc3 & 0xfff0) / 118.85795 - 160
            print("value: \(value.map { String(format: "%02hhx", $0) }.joined())")
            print("adc0: \(adc0), adc1: \(adc1 >> 4), adc2: \(adc2), adc3: \(adc3)")
            print("voltage: \(voltage), temperature: \(temperature)")
            print("voltagec: \(voltagec), temperaturec: \(temperaturec)")
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationState isNotifying: \(characteristic.isNotifying) value: \(String(describing: characteristic.value)) error: \(String(describing: error))")
    }
}

// Letters are numbered according to SBrick app; raw values match channels
// --o--
// aa bb
// cc dd
// --|--
public enum SBrickChannel: UInt8 {
    case a = 0x00, b = 0x02, c = 0x01, d = 0x03
}

extension SBrick {
    open func motor(for channel: SBrickChannel) -> SBrickMotor {
        return SBrickMotor(device: self, channel: channel)
    }
    
    open func quickDrive(for channel: SBrickChannel) -> SBrickQuickDrive {
        return SBrickQuickDrive(device: self, channel: channel)
    }
}

extension SBrick {
    func write(_ command: SBrickCommand, characteristic: CBCharacteristic) {
        if !command.value.isEmpty {
            peripheral.writeValue(command.value, for: characteristic, type: .withoutResponse)
        }
    }
    
    func write(_ command: SBrickRemoteControlCommand) {
        if let remoteControlCommandsCharacteristic = remoteControlCommandsCharacteristic {
            write(command, characteristic: remoteControlCommandsCharacteristic)
        }
    }
    
    func write(_ command: SBrickQuickDriveCommand) {
        if let quickDriveCharacteristic = quickDriveCharacteristic {
            write(command, characteristic: quickDriveCharacteristic)
        }
    }
}

var b = true
extension SBrick {
    func read(_ channel: SBrickChannel) {
        if let remoteControlCommandsCharacteristic = remoteControlCommandsCharacteristic {
            if b {
                let command1 = SBrickRemoteControlCommand(commandIdentifier: .setUpPeriodicVoltageMeasurement, data: Data(bytes: [0x00, 0x01, 0x08, 0x09]))
                write(command1, characteristic: remoteControlCommandsCharacteristic)
                
                b = false
            }
            let command2 = SBrickRemoteControlCommand(commandIdentifier: .queryADC, data: Data(bytes: [0x00, 0x01, 0x08, 0x09]))
            write(command2, characteristic: remoteControlCommandsCharacteristic)

            peripheral.readValue(for: remoteControlCommandsCharacteristic)
            
        }
    }
}
