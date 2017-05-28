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
    fileprivate let smartBrickManager = SmartBrickManager()
    
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
        window?.delegate = self
        
        smartBrickManager.delegate = self
        smartBrickManager.scanForDevices()
        
        listViewController?.delegate = self
    }
}

extension WindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        // Workaround for the issue that smartBrickManager's destructor isn't
        // called when destroying the window
        smartBrickManager.disconnectAll()
    }
}

extension WindowController: SmartBrickManagerDelegate {
    func smartBrickManager(_ smartBrickManager: SmartBrickManager, didDiscover smartBrickDescription: SmartBrickDescription) {
        listViewController?.updateList(with: smartBrickDescription)
    }
}

extension WindowController: SmartBrickListViewControllerDelegate {
    func smartBrickListViewController(_ smartBrickListViewController: SmartBrickListViewController, didSelect smartBrickDescription: SmartBrickDescription) {
        print("Selected \(String(describing: smartBrickDescription.name))")

        smartBrickManager.connect(smartBrickDescription) { smartBrick in
            print("Connected \(String(describing: smartBrick))")
        }
    }
}
