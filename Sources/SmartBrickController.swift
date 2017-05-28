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
    
    fileprivate struct ConnectingDevice {
        var smartBrickDescription: SmartBrickDescription
        var peripheral: CBPeripheral
        var completionBlock: (SmartBrick?) -> Void
    }
    fileprivate var connectingDevices = [UUID: ConnectingDevice]()

    weak var delegate: SmartBrickControllerDelegate?
    
    override init() {
        central = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        central.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
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
        // Indicate that we shouldn't be scanning so delegate callbacks won't start a scan if we're not scanning right now.
        shouldBeScanning = false
        
        central.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            let deviceType: SmartBrickDescription.DeviceType?
            if SBrick.isValidDevice(manufacturerData: manufacturerData) {
                deviceType = .sBrick
            } else if SBrickPlus.isValidDevice(manufacturerData: manufacturerData) {
                deviceType = .sBrickPlus
            } else {
                deviceType = nil
            }

            if let deviceType = deviceType {
                let smartBrickDescription = SmartBrickDescription(identifier: peripheral.identifier, name: peripheral.name, deviceType: deviceType)
                delegate?.smartBrickController(self, didDiscover: smartBrickDescription)
            }
        }
    }
}

extension SmartBrickController {
    func connect(_ smartBrickDescription: SmartBrickDescription, completionHandler: @escaping ((SmartBrick?) -> Void)) {
        guard let peripheral = central.retrievePeripherals(withIdentifiers: [smartBrickDescription.identifier]).first else {
            completionHandler(nil)
            return
        }

        connectingDevices[smartBrickDescription.identifier] = ConnectingDevice(smartBrickDescription: smartBrickDescription, peripheral: peripheral, completionBlock: completionHandler)
        central.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let connectingDevice = connectingDevices[peripheral.identifier] {
            connectingDevices[peripheral.identifier] = nil

            let smartBrick: SmartBrick?
            switch connectingDevice.smartBrickDescription.deviceType {
            case .sBrick:
                smartBrick = SBrick(peripheral: peripheral)
            case .sBrickPlus:
                smartBrick = SBrickPlus(peripheral: peripheral)
            }
            connectingDevice.completionBlock(smartBrick)
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let connectingDevice = connectingDevices[peripheral.identifier] {
            connectingDevices[peripheral.identifier] = nil
            connectingDevice.completionBlock(nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
    }
}
