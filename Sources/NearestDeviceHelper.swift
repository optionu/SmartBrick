//
//  NearestDeviceHelper.swift
//  SmartBricks
//
//  Created by Claus Höfele on 07.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

class NearestDeviceHelper: SmartBricksControllerDelegate {
    let completionBlock: ((SmartBrick?) -> Void)

    init(completionBlock: @escaping ((SmartBrick?) -> Void)) {
        self.completionBlock = completionBlock
    }

    func smartBricksController(_ smartBricksController: SmartBricksController, didDiscover smartBrick: SmartBrick) {
        smartBricksController.stopScanning()
        completionBlock(smartBrick)
    }
}
