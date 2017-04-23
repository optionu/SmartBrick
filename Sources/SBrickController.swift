//
//  SBrickController.swift
//  SmartBrick
//
//  Created by Claus Höfele on 19.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

private let remoteControlServiceUUID = CBUUID(string:"4dc591b0-857c-41de-b5f1-15abda665b0c")
private let quickDriveCharacteristicUUID = CBUUID(string: "489a6ae0-c1ab-4c9c-bdb2-11d373c1b7fb")
private let remoteControlCommandsCharacteristicUUID = CBUUID(string: "02b8cbcc-0e25-4bda-8790-a15f53e6010f")
private let remoteControlCharacteristicUUIDs = [quickDriveCharacteristicUUID, remoteControlCommandsCharacteristicUUID]

enum SBrickChannel: UInt8 {
    case ac1 = 0x00
    case ac2 = 0x01
    case bc1 = 0x02
    case bc2 = 0x03
    case cc1 = 0x04
    case cc2 = 0x05
    case dc1 = 0x06
    case dc2 = 0x07
    case batteryVoltage = 0x08
    case temperature = 0x09
}

protocol SBrickControllerDelegate: class {
    func sbrickControllerDidDiscoverServices(_ sbrickController: SBrickController)
    func sbrickController(_ sbrickController: SBrickController, didReceiveSensorValue value: UInt16, for channel: SBrickChannel)
}

class SBrickController: NSObject, CBPeripheralDelegate {
    weak var delegate: SBrickControllerDelegate?
    
    var remoteControlCommandsCharacteristic: CBCharacteristic?
    var quickDriveCharacteristic: CBCharacteristic?

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
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
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
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
            delegate?.sbrickControllerDidDiscoverServices(self)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didWriteValue value: \(String(describing: characteristic.value)) error: \(String(describing: error))")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor value: \(String(describing: characteristic.value)) error: \(String(describing: error))")
        
        SBrickController.readValues(characteristic.value ?? Data())
            .flatMap(SBrickController.splitValue)
            .forEach { (adc: UInt16, channel: SBrickChannel) in
                print("adc: \(adc) channel: \(channel)")
                delegate?.sbrickController(self, didReceiveSensorValue: adc, for: channel)
        }
    }
    
    static func readValues(_ data: Data) -> [UInt16] {
        var values = [UInt16]()
        
        let binaryReader = BinaryReader(withData: data, bigEndian: false)
        while binaryReader.canRead(numberOfBytes: MemoryLayout<UInt16>.size) {
            values.append(binaryReader.readUInt16())
        }
        
        return values
    }
    
    static func splitValue(_ raw: UInt16) -> (adc: UInt16, channel: SBrickChannel)? {
        let channelRaw = UInt8(raw & 0x000f)
        guard let channel = SBrickChannel(rawValue: channelRaw) else { return nil }
        let adc = (raw & 0xfff0) >> 4
        
        return (adc, channel)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationState isNotifying: \(characteristic.isNotifying) value: \(String(describing: characteristic.value)) error: \(String(describing: error))")
    }
}
