//
//  SBrick.swift
//  SmartBricks
//
//  Created by Claus Höfele on 04/04/17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol SmartBrick: class {
    var peripheral: CBPeripheral { get }
    
    func prepareConnection(completionHandler: @escaping (() -> Void))
}

public protocol IOChannel {
}
