//
//  SBrick.swift
//  SmartBricks
//
//  Created by Claus Höfele on 04/04/17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

// Enum instead?
public protocol SmartBrick {
    var peripheral: CBPeripheral { get }
    
    func prepareConnection(completionHandler: @escaping (() -> Void))
}
