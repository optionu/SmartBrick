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
    private var deviceHelper: SmartBricksControllerDelegate?

    public init() {
        controller = SmartBricksController()
        controller.delegate = self
    }
    
    public func connectToNearestDevice(completionBlock: @escaping ((SmartBrick?) -> Void)) {
        deviceHelper = NearestDeviceHelper() { smartBrick in
            self.controller.delegate = self
            self.deviceHelper = nil
            
            completionBlock(smartBrick)
        }
        controller.delegate = deviceHelper
        controller.scanForDevices()
    }
    
    public func scanForDevices() {
        controller.scanForDevices()
    }
    
    public func stopScanning() {
        controller.stopScanning()
    }

    func smartBricksController(_ smartBricksController: SmartBricksController, didDiscover smartBrick: SmartBrick) {
        delegate?.smartBricksManager(self, didDiscover: smartBrick)
    }
}
