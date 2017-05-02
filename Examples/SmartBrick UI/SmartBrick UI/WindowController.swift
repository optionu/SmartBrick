//
//  WindowController.swift
//  SmartBrick UI
//
//  Created by Claus Höfele on 02.05.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa
import SmartBrick

class WindowController: NSWindowController {
    private let smartBrickManager = SmartBrickManager()
    
    fileprivate var listViewController: SmartBrickListViewController? {
        let splitViewController = window?.contentViewController as? NSSplitViewController
        let listViewController = splitViewController?.splitViewItems[0].viewController as? SmartBrickListViewController
        return listViewController
    }
    
    fileprivate var itemViewController: SmartBrickViewController? {
        let splitViewController = window?.contentViewController as? NSSplitViewController
        let itemViewController = splitViewController?.splitViewItems[1].viewController as? SmartBrickViewController
        return itemViewController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.titleVisibility = .hidden
        
        smartBrickManager.delegate = self
        smartBrickManager.scanForDevices()
        
        listViewController?.delegate = self
    }
}

extension WindowController: SmartBrickManagerDelegate {
    func smartBrickManager(_ smartBrickManager: SmartBrickManager, didDiscover smartBrick: SmartBrick) {
        listViewController?.updateList(with: smartBrick)
    }
}

extension WindowController: SmartBrickListViewControllerDelegate {
    func smartBrickListViewController(_ smartBrickListViewController: SmartBrickListViewController, didSelect smartBrick: SmartBrick) {
        print("Selected \(String(describing: smartBrick.peripheral.name))")
    }
}
