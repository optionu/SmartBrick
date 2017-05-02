//
//  WindowController.swift
//  SmartBrick UI
//
//  Created by Claus Höfele on 02.05.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.titleVisibility = .hidden
    }
}
