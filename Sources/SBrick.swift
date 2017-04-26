//
//  SBricks.swift
//  SmartBricks
//
//  Created by Claus Höfele on 10.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol SBrickDelegate {
    func sbrick(_ sbrick: SBrick, didReceiveSensorValue value: UInt16, for channel: SBrickChannel)
}

open class SBrick: SmartBrick {
    public let peripheral: CBPeripheral
    
    var delegates = SBrickDelegates()
    fileprivate var completionBlock: (() -> Void)?
    fileprivate let controller: SBrickController
    
    public convenience init?(peripheral: CBPeripheral, manufacturerData: Data) {
        self.init(peripheral: peripheral, manufacturerData: manufacturerData, shouldBePlus: false)
    }
    
    init?(peripheral: CBPeripheral, manufacturerData: Data, shouldBePlus: Bool) {
        guard SBrick.isValidDevice(manufacturerData: manufacturerData, testForSBrickPlus: shouldBePlus) else { return nil }
        
        self.peripheral = peripheral
        controller = SBrickController()
        controller.delegate = self
        peripheral.delegate = controller
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
        print("discoverServices")
        
        completionBlock = completionHandler
        
        // SBrick doesn't allow discovering specific services
        peripheral.discoverServices(nil)
    }
}

extension SBrick: SBrickControllerDelegate {
    func sbrickControllerDidDiscoverServices(_ sbrickController: SBrickController) {
        completionBlock?()
    }
    
    func sbrickController(_ sbrickController: SBrickController, didReceiveSensorValue value: UInt16, for channel: SBrickChannel) {
        delegates.dispatch(self, didReceiveSensorValue: value, for: channel)
    }
}

// Letters are numbered according to SBrick app; raw values match ports
// --o--
// aa bb
// cc dd
// --|--
public enum SBrickPort: UInt8 {
    case a = 0x00, b = 0x02, c = 0x01, d = 0x03
}

extension SBrick {
    open func motor(for port: SBrickPort) -> SBrickMotor {
        return SBrickMotor(device: self, port: port)
    }
    
    open func quickDrive(for port: SBrickPort) -> SBrickQuickDrive {
        return SBrickQuickDrive(device: self, port: port)
    }
}

extension SBrick {
    func write(_ command: SBrickCommand, characteristic: CBCharacteristic) {
        if !command.value.isEmpty {
            peripheral.writeValue(command.value, for: characteristic, type: .withoutResponse)
        }
    }
    
    func write(_ command: SBrickRemoteControlCommand) {
        if let remoteControlCommandsCharacteristic = controller.remoteControlCommandsCharacteristic {
            write(command, characteristic: remoteControlCommandsCharacteristic)
        }
    }
    
    func write(_ command: SBrickQuickDriveCommand) {
        if let quickDriveCharacteristic = controller.quickDriveCharacteristic {
            write(command, characteristic: quickDriveCharacteristic)
        }
    }
}

var b = true
extension SBrick {
    func read(_ port: SBrickPort) {
        if let remoteControlCommandsCharacteristic = controller.remoteControlCommandsCharacteristic {
            if b {
                let command = SBrickRemoteControlCommand.setUpPeriodicVoltageMeasurementCommand(channels: [.ac1, .ac2])
                write(command)
                
                b = false
            }
            
            let command = SBrickRemoteControlCommand.queryADCCommand(channels: [.ac1, .ac2, .batteryVoltage, .temperature])
            write(command)

            peripheral.readValue(for: remoteControlCommandsCharacteristic)
        }
    }
}
