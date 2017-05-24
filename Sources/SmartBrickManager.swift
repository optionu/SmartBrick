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
    func smartBrickManager(_ smartBrickManager: SmartBrickManager, didDiscover smartBrickDescription: SmartBrickDescription)
}

public final class SmartBrickManager {
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

    public func connect(_ smartBrickDescription: SmartBrickDescription, completionBlock: @escaping ((SmartBrick?) -> Void)) {
        controller.connect(smartBrickDescription, completionHandler: completionBlock)
    }
}

extension SmartBrickManager: SmartBrickControllerDelegate {
    func smartBrickController(_ smartBrickController: SmartBrickController, didDiscover smartBrickDescription: SmartBrickDescription) {
        delegate?.smartBrickManager(self, didDiscover: smartBrickDescription)
    }
}
