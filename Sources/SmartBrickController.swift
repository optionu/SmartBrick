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
    func smartBrickController(_ smartBrickController: SmartBrickController, didDiscover smartBrickDescription: SmartBrickDescription)
}

class SmartBrickController: NSObject, CBCentralManagerDelegate {
    fileprivate let central: CBCentralManager
    fileprivate var shouldBeScanning = false
    fileprivate var connectingDevices = [UUID: (SmartBrickDescription, (SmartBrick?) -> Void)]()

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
        if let _ = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
//            if let smartBrick = SBrick(peripheral: peripheral, manufacturerData: manufacturerData) {
//                delegate?.smartBrickController(self, didDiscover: smartBrick)
//            } else if let smartBrick = SBrickPlus(peripheral: peripheral, manufacturerData: manufacturerData) {
//                delegate?.smartBrickController(self, didDiscover: smartBrick)
//            }
            let smartBrickDescription = SmartBrickDescription(identifier: peripheral.identifier, name: peripheral.name, deviceType: .sBrick)
            delegate?.smartBrickController(self, didDiscover: smartBrickDescription)
        }
    }
}

extension SmartBrickController {
    func connect(_ smartBrickDescription: SmartBrickDescription, completionHandler: @escaping ((SmartBrick?) -> Void)) {
        print("connect")

        guard let peripheral = central.retrievePeripherals(withIdentifiers: [smartBrickDescription.identifier]).first else {
            completionHandler(nil)
            return
        }

        connectingDevices[smartBrickDescription.identifier] = (smartBrickDescription, completionHandler)
        central.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        if let (description, completionBlock) = connectingDevices[peripheral.identifier] {
            print("didConnect completionBlock")
            connectingDevices[peripheral.identifier] = nil

            let smartBrick: SmartBrick?
            switch description.deviceType {
            case .sBrick:
                smartBrick = SBrick(peripheral: peripheral)
            case .sBrickPlus:
                smartBrick = SBrickPlus(peripheral: peripheral)
            }
            completionBlock(smartBrick)
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect")
        if let (_, completionBlock) = connectingDevices[peripheral.identifier] {
            print("didFailToConnect completionBlock")
            connectingDevices[peripheral.identifier] = nil
            completionBlock(nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
    }
}
