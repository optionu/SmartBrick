//
//  SmartBricks.swift
//  SmartBricks
//
//  Created by Claus Höfele on {TODAY}.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

private let service = CBUUID(string: "22bb746f-2ba0-7554-2d6f-726568705327")

public final class SmartBrickManager {
    private let deviceController: DeviceController
    private let central: CBCentralManager

    public init() {
        deviceController = DeviceController()
        central = CBCentralManager(delegate: deviceController, queue: nil)
    }

    public func scanForDevices() {
        deviceController.scanForDevices(central)
    }

    // nearest in SpheroManager
    // https://github.com/Stolpersteine/stolpersteine-ios/commit/cece6e39cf63d2415beb92ecde6afd1454d564f7#diff-12e03f696d3c073de86e0a3dd24808e6
    // async?
    public func findNearestDevice(rememberLastDevice: Bool, completionHandler: (SmartBrick?) -> Void) {
        completionHandler(nil)
    }
}

class DeviceController: NSObject, CBCentralManagerDelegate {
    private var shouldBeScanning = false
    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState \(central.state.rawValue)")

        switch central.state {
        case .poweredOn:
            if shouldBeScanning {
                scanForDevices(central)
            }
        case .poweredOff:
            stopScanning(central)
        case .resetting:
            break
        case .unauthorized, .unknown, .unsupported:
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        discoveredPeripherals[peripheral.identifier] = peripheral

//        CFRunLoopPerformBlock(CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue) {
//            self.delegate?.spheroManager(self, didDiscover: SpheroDescription(name: peripheral.name, identifier: peripheral.identifier, rssi: rssi.intValue))
//        }
//        CFRunLoopWakeUp(CFRunLoopGetMain())
//        print("didDiscover \(peripheral.identifier) \(peripheral.name) \(advertisementData)")
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
            let smartBrick = SBrick(identifier: peripheral.identifier, name: peripheral.name, manufacturerData: manufacturerData) {
            print("Found \(smartBrick.name ?? "<unknown>") \(smartBrick.identifier)")
        }
    }

    func scanForDevices(_ central: CBCentralManager) {
        // Indicate that we should be scanning so delegate callbacks will start a scan if we can't right now.
        shouldBeScanning = true

        // This method can only do anything if the CBCentralManager is poweredOn.
        // It doesn't need to do anything else if it's already scanning.
        // If either of those things are true, return early.
        guard central.state == .poweredOn else { return }
            //&& !central.isScanning else { return }

        print("scanForDevices")
        central.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning(_ central: CBCentralManager) {
        // Indicate that we shouldn't be scanning so delegate callbacks won't start a scan if we're not scanning right now.
        shouldBeScanning = false

        // This method can only do anything if the CBCentralManager is currently scanning.
        // If we aren't, then this method can just return without doing anything.
//        guard central.isScanning else { return }

        central.stopScan()
    }
}
