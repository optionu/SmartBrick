//
//  SmartBricks.swift
//  SmartBricks
//
//  Created by Claus Höfele on {TODAY}.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol SmartBrickManagerDelegate: class {
    func smartBrickManager(_ smartBrickManager: SmartBrickManager, didDiscover smartBrick: SmartBrick)
}

public final class SmartBrickManager: SmartBrickControllerDelegate {
    public weak var delegate: SmartBrickManagerDelegate?

    private let controller: SmartBrickController
    private var deviceHelper: SmartBrickControllerDelegate?

    public init() {
        controller = SmartBrickController()
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

    func smartBricksController(_ smartBrickController: SmartBrickController, didDiscover smartBrick: SmartBrick) {
        delegate?.smartBrickManager(self, didDiscover: smartBrick)
    }
}
