//
//  SmartBricks.swift
//  SmartBricks
//
//  Created by Claus Höfele on {TODAY}.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol SmartBricksManagerDelegate: class {
    func smartBricksManager(_ smartBricksManager: SmartBricksManager, didDiscover smartBrick: SmartBrick)
}

public final class SmartBricksManager: SmartBricksControllerDelegate {
    public weak var delegate: SmartBricksManagerDelegate?

    private let controller: SmartBricksController
    private let central: CBCentralManager

    public init() {
        controller = SmartBricksController()
        central = CBCentralManager(delegate: controller, queue: nil)
        controller.delegate = self
    }
    
    public func scanForDevices() {
        controller.scanForDevices(central)
    }
    
    public func stopScanning() {
        controller.stopScanning(central)
    }

    func smartBricksController(_ smartBricksController: SmartBricksController, didDiscover smartBrick: SmartBrick) {
        delegate?.smartBricksManager(self, didDiscover: smartBrick)
    }
}
