//
//  SBrick.swift
//  SmartBricks
//
//  Created by Claus Höfele on 04/04/17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

public struct SmartBrickDescription {
    public var identifier: UUID
    public var name: String?

    public enum DeviceType {
        case sBrick
        case sBrickPlus
    }

    public var deviceType: DeviceType
}

public protocol SmartBrick: class {
    var peripheral: CBPeripheral { get }
}

public protocol IOChannel {
}
