//
//  NearestDeviceHelper.swift
//  SmartBricks
//
//  Created by Claus Höfele on 07.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

class NearestDeviceHelper: SmartBricksManagerDelegate {
    let timeout: TimeInterval

    init(timeout: TimeInterval) {
        self.timeout = timeout
    }

    func smartBricksManager(_ smartBricksManager: SmartBricksManager, didDiscover smartBrick: SmartBrick) {
    }
}
