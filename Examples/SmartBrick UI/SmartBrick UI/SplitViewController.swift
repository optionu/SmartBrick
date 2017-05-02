//
//  ViewController.swift
//  SmartBrick UI
//
//  Created by Claus Höfele on 01.05.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa
import SmartBrick

class SplitViewController: NSSplitViewController {
    @IBOutlet private weak var listViewItem: NSSplitViewItem!
    @IBOutlet private weak var itemViewItem: NSSplitViewItem!
    
    fileprivate var listViewController: SmartBrickListViewController? {
        return listViewItem.viewController as? SmartBrickListViewController
    }
    
    private var itemViewController: SmartBrickViewController? {
        return itemViewItem.viewController as? SmartBrickViewController
    }
    
    private let smartBrickManager = SmartBrickManager()
    private var connectedSmartBrick: SBrick?
    private var motionSensor: SBrickMotionSensor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smartBrickManager.delegate = self
        smartBrickManager.scanForDevices()
        
//        smartBricksManager.connectToNearestDevice() { smartBrick in
//            switch smartBrick {
//            case let sbrick as SBrick:
//                self.connectedSmartBrick = sbrick
//                let name = sbrick.peripheral.name ?? "<unknown>"
//                self.itemViewController?.connectionState = .connected(name)
//            default:
//                print("No smart brick found")
//            }
//        }
        
        itemViewController?.updateActuator = { portValue, powerValue in
            //    let port = SBrickPort(rawValue: UInt8(portValue)) ?? .a
            //    let motor = connectedSmartBrick?.motor(for: port)
            //    let power = UInt8(abs(powerValue))
            //    let direction: SBrickMotorDirection = powerValue > 0 ? .clockwise : .counterclockwise
            //    motor?.drive(direction: direction, power: power)
            
            //    let port = SBrickPort(rawValue: UInt8(portValue)) ?? .a
            //    let quickDrive = connectedSmartBrick?.quickDrive(for: port)
            //    let power = UInt8(abs(powerValue))
            //    let direction: MotorDirection = powerValue > 0 ? .clockwise : .counterclockwise
            //    quickDrive?.changePortMapping(port0: .a, port1: .a, port2: .a, port3: .a)
            //    quickDrive?.drive(portValues: [(direction, power)])
            
            let port = SBrickPort(rawValue: UInt8(portValue)) ?? .a
            self.motionSensor = self.connectedSmartBrick?.motionSensor(for: port)
            self.motionSensor?.retrieveDistance()
        }
    }
}

extension SplitViewController: SmartBrickManagerDelegate {
    func smartBrickManager(_ smartBrickManager: SmartBrickManager, didDiscover smartBrick: SmartBrick) {
        listViewController?.updateList(with: smartBrick)
    }
}
