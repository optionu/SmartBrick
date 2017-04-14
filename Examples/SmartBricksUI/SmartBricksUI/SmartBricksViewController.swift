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
    @IBOutlet weak var sliderB: NSSlider!
    @IBOutlet weak var sliderC: NSSlider!
    @IBOutlet weak var sliderD: NSSlider!
    
    @IBOutlet weak var stopA: NSButton!
    @IBOutlet weak var stopB: NSButton!
    @IBOutlet weak var stopC: NSButton!
    @IBOutlet weak var stopD: NSButton!
    
    open var updateActuator: ((Int, Int) -> Void)?
    
    @IBAction func sliderChanged(_ sender: NSSlider) {
        let channel: Int?
        if sender == sliderA {
            channel = 0
        } else if sender == sliderB {
            channel = 2
        } else if sender == sliderC {
            channel = 1
        } else if sender == sliderD {
            channel = 3
        } else {
            channel = nil
            assert(false, "Invalid slider")
        }
        
        if let channel = channel {
            updateActuator?(channel, sender.integerValue)
        }
    }
    
    @IBAction func stopClicked(_ sender: NSButton) {
        let slider: NSSlider?
        if sender == stopA {
            slider = sliderA
        } else if sender == stopB {
            slider = sliderB
        } else if sender == stopC {
            slider = sliderC
        } else if sender == stopD {
            slider = sliderD
        } else {
            slider = nil
            assert(false, "Invalid slider")
        }
        
        if let slider = slider {
            slider.integerValue = 0
            sliderChanged(slider)
        }
    }
}
