//
//  ViewController.swift
//  SmartBricks UI
//
//  Created by Claus Höfele on 14.04.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa

open class SmartBricksViewController: NSViewController {
    @IBOutlet weak var sliderA: NSSlider!
    
    open var sliderChanged: ((Int) -> Void)?
    open var stop: (() -> Void)?
    
    @IBAction func sliderAChanged(_ sender: NSSlider) {
        sliderChanged?(sender.integerValue)
    }
    
    @IBAction func stopA(_ sender: NSButton) {
        sliderA.integerValue = 0
        stop?()
    }
}
