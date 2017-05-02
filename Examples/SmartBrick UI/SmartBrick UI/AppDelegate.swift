//
//  AppDelegate.swift
//  SmartBrick UI
//
//  Created by Claus Höfele on 01.05.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

