//
//  SBrickPlus.swift
//  SmartBricks
//
//  Created by Claus Höfele on 10.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

open class SBrickPlus: SBrick {
    public init?(peripheral: CBPeripheral, manufacturerData: Data) {
        super.init(peripheral: peripheral, manufacturerData: manufacturerData, shouldBePlus: true)
    }
}

extension SBrickPlus {
    // Letters are numbered according to SBrick app; numbers match channels
    public enum Channel: UInt8 {
        case a = 0, b = 2, c = 1, d = 3, voltage = 8, temperature = 9
    }
    
    open func retrieveSensorValue(channel: Channel) {
        if let remoteControlCommandsCharacteristic = remoteControlCommandsCharacteristic {
            let data = Data(bytes: [0x0F, channel.rawValue])
            peripheral.writeValue(data, for: remoteControlCommandsCharacteristic, type: .withoutResponse)
            peripheral.readValue(for: remoteControlCommandsCharacteristic)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor \(String(describing: characteristic.value))")
    }
}
