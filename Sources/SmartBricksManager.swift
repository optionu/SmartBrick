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
    public var delegate: SmartBricksManagerDelegate?

    private let controller: SmartBricksController
    private let central: CBCentralManager

    public init() {
        controller = SmartBricksController()
        central = CBCentralManager(delegate: controller, queue: nil)
    }

    public func scanForDevices() {
        controller.scanForDevices(central)
    }

    // nearest in SpheroManager
    // https://github.com/Stolpersteine/stolpersteine-ios/commit/cece6e39cf63d2415beb92ecde6afd1454d564f7#diff-12e03f696d3c073de86e0a3dd24808e6
    // async?
    public func findNearestDevice(rememberLastDevice: Bool, completionHandler: (SmartBrick?) -> Void) {
//        let nearestDeviceHelper = NearestDeviceHelper(timeout: 1)
//        let previousDelegate = delegate
//        delegate = nearestDeviceHelper
//        defer { delegate = previousDelegate }
//
//        scanForDevices()

        completionHandler(nil)
    }

    func smartBricksController(_ smartBricksController: SmartBricksController, didDiscover smartBrick: SmartBrick) {
        delegate?.smartBricksManager(self, didDiscover: smartBrick)
    }
}
