//
//  SmartBricksController.swift
//  SmartBricks
//
//  Created by Claus Höfele on 07.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol SmartBrickControllerDelegate: class {
    func smartBrickController(_ smartBrickController: SmartBrickController, didDiscover smartBrick: SmartBrick)
}

class SmartBrickController: NSObject, CBCentralManagerDelegate {
    fileprivate let central: CBCentralManager
    fileprivate var shouldBeScanning = false
    fileprivate var connectingDevices = [UUID: () -> Void]()

    weak var delegate: SmartBrickControllerDelegate?
    
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

extension SmartBrickController {
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
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            if let smartBrick = SBrick(peripheral: peripheral, manufacturerData: manufacturerData) {
                delegate?.smartBrickController(self, didDiscover: smartBrick)
            } else if let smartBrick = SBrickPlus(peripheral: peripheral, manufacturerData: manufacturerData) {
                delegate?.smartBrickController(self, didDiscover: smartBrick)
            }
        }
    }
}

extension SmartBrickController {
    func connect(peripheral: CBPeripheral, completionHandler: @escaping (() -> Void)) {
        print("connect")
        connectingDevices[peripheral.identifier] = completionHandler
        central.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        if let completionBlock = connectingDevices[peripheral.identifier] {
            print("didConnect completionBlock")
            connectingDevices[peripheral.identifier] = nil
            completionBlock()
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect")
        if let completionBlock = connectingDevices[peripheral.identifier] {
            print("didFailToConnect completionBlock")
            connectingDevices[peripheral.identifier] = nil
            completionBlock()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
    }
}
