//
//  NearestDeviceHelper.swift
//  SmartBricks
//
//  Created by Claus Höfele on 07.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

open class NearestDeviceHelper: SmartBricksManagerDelegate {
    open let timeout: TimeInterval
    open private(set) var completionBlock: ((SmartBrick?) -> Void)

    public init(timeout: TimeInterval, completionBlock: @escaping ((SmartBrick?) -> Void)) {
        self.timeout = timeout
        self.completionBlock = completionBlock
    }

    open func smartBricksManager(_ smartBricksManager: SmartBricksManager, didDiscover smartBrick: SmartBrick) {
        smartBricksManager.stopScanning()
        completionBlock(smartBrick)
    }
}
