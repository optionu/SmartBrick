//
//  NearestDeviceHelper.swift
//  SmartBricks
//
//  Created by Claus Höfele on 07.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

class NearestDeviceHelper: SmartBrickControllerDelegate {
    let completionBlock: ((SmartBrick?) -> Void)

    init(completionBlock: @escaping ((SmartBrick?) -> Void)) {
        self.completionBlock = completionBlock
    }

    func smartBrickController(_ smartBrickController: SmartBrickController, didDiscover smartBrick: SmartBrick) {
//        smartBrickController.stopScanning()
//        smartBrickController.connect(peripheral: smartBrick.peripheral) {
//            smartBrick.prepareConnection() {
//                self.completionBlock(smartBrick)
//            }
//        }
    }
}
