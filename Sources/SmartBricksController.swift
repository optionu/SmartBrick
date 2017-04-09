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
    private let central: CBCentralManager
    private var shouldBeScanning = false
    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]

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

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        discoveredPeripherals[peripheral.identifier] = peripheral
        print("didDiscover")
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
            let smartBrick = SBrick(identifier: peripheral.identifier, name: peripheral.name, manufacturerData: manufacturerData) {
            delegate?.smartBricksController(self, didDiscover: smartBrick)
        }
    }

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
}
