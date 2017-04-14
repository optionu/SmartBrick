import Cocoa
import SmartBricks
import SmartBricksUI
import PlaygroundSupport

let bundle = Bundle(for: SmartBricksViewController.self)
let storyboard = NSStoryboard(name: "SmartBricks", bundle: bundle)
let viewController = storyboard.instantiateInitialController() as! SmartBricksViewController
PlaygroundPage.current.liveView = viewController

var connectedSmartBrick: SBrick?

viewController.updateActuator = { channelValue, value in
    value
//    connectedSmartBrick?.updateQuickDrive(value0: UInt8(value), direction0: .clockwise)
    let channel = SBrick.Channel(rawValue: UInt8(channelValue)) ?? .a
    connectedSmartBrick?.updateDrive(channel: channel, value: UInt8(value), direction: .clockwise)
}

let smartBricksManager = SmartBricksManager()
smartBricksManager.connectToNearestDevice() { smartBrick in
    switch smartBrick {
    case let sbrick as SBrick:
        print("Connected to SBrick \"\(sbrick.peripheral.name ?? "<unknown>")\"")
        connectedSmartBrick = sbrick
    default:
        print("No smart brick found")
    }
}
