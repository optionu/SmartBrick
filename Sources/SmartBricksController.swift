//
//  SmartBricksController.swift
//  SmartBricks
//
//  Created by Claus Höfele on 07.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol SmartBricksControllerDelegate: class {
    func smartBricksController(_ smartBricksController: SmartBricksController, didDiscover smartBrick: SmartBrick)
}

class SmartBricksController: NSObject, CBCentralManagerDelegate {
    fileprivate let central: CBCentralManager
    fileprivate var shouldBeScanning = false

    weak var delegate: SmartBricksControllerDelegate?
    
    override init() {
        central = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        central.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState \(central.state.rawValue)")

        switch central.state {
        case .poweredOn:
            if shouldBeScanning {
                scanForDevices()
            }
        case .poweredOff:
            break
        case .resetting:
            break
        case .unauthorized, .unknown, .unsupported:
            break
        }
    }
}

extension SmartBricksController {
    func scanForDevices() {
        // Indicate that we should be scanning so delegate callbacks will start a scan if we can't right now.
        shouldBeScanning = true
        
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        print("stopScanning")
        
        // Indicate that we shouldn't be scanning so delegate callbacks won't start a scan if we're not scanning right now.
        shouldBeScanning = false
        
        central.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        print("didDiscover")
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
            let smartBrick = SBrick(peripheral: peripheral, manufacturerData: manufacturerData) {
            delegate?.smartBricksController(self, didDiscover: smartBrick)
        }
    }
}

extension SmartBricksController {
    func connect(peripheral: CBPeripheral, completionHandler: @escaping ((SmartBrick?) -> Void)) {
        central.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
}
