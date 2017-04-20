//
//  ViewController.swift
//  SmartBricks UI
//
//  Created by Claus Höfele on 14.04.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa

open class SmartBrickViewController: NSViewController {
    @IBOutlet weak var sliderA: NSSlider!
    @IBOutlet weak var sliderB: NSSlider!
    @IBOutlet weak var sliderC: NSSlider!
    @IBOutlet weak var sliderD: NSSlider!
    
    @IBOutlet weak var stopButtonA: NSButton!
    @IBOutlet weak var stopButtonB: NSButton!
    @IBOutlet weak var stopButtonC: NSButton!
    @IBOutlet weak var stopButtonD: NSButton!
    
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var connectProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var deviceNameLabel: NSTextField!
    
    public enum ConnectionState {
        case connecting
        case connected(String)
    }
    open var connectionState: ConnectionState = .connecting { didSet {
            updateConnectionState()
        }
    }
    open var updateActuator: ((Int, Int) -> Void)?
    
    open override func viewDidLoad() {
        updateConnectionState()
    }
    
    @IBAction func sliderChanged(_ sender: NSSlider) {
        let port: Int?
        if sender == sliderA {
            port = 0
        } else if sender == sliderB {
            port = 2
        } else if sender == sliderC {
            port = 1
        } else if sender == sliderD {
            port = 3
        } else {
            port = nil
            assert(false, "Invalid slider")
        }
        
        if let port = port {
            updateActuator?(port, sender.integerValue)
        }
    }
    
    @IBAction func stopClicked(_ sender: NSButton) {
        let slider: NSSlider?
        if sender == stopButtonA {
            slider = sliderA
        } else if sender == stopButtonB {
            slider = sliderB
        } else if sender == stopButtonC {
            slider = sliderC
        } else if sender == stopButtonD {
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
    
    func updateConnectionState() {
        switch connectionState {
        case .connecting:
            connectButton.title = "Connecting…"
            connectProgressIndicator.startAnimation(self)
            connectProgressIndicator.isHidden = false
            deviceNameLabel.stringValue = ""
            updateControls(enabled: false)
        case .connected(let deviceName):
            connectButton.title = "Reconnect"
            connectProgressIndicator.stopAnimation(self)
            connectProgressIndicator.isHidden = true
            deviceNameLabel.stringValue = deviceName
            updateControls(enabled: true)
        }
    }
    
    func updateControls(enabled: Bool) {
        sliderA.isEnabled = enabled
        sliderB.isEnabled = enabled
        sliderC.isEnabled = enabled
        sliderD.isEnabled = enabled
        
        stopButtonA.isEnabled = enabled
        stopButtonB.isEnabled = enabled
        stopButtonC.isEnabled = enabled
        stopButtonD.isEnabled = enabled
    }
}
