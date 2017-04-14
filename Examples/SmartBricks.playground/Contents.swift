import Cocoa
import SmartBricks
import SmartBricksUI
import PlaygroundSupport

let bundle = Bundle(for: SmartBricksViewController.self)
let storyboard = NSStoryboard(name: "SmartBricks", bundle: bundle)
let viewController = storyboard.instantiateInitialController() as! SmartBricksViewController
PlaygroundPage.current.liveView = viewController

var connectedSmartBrick: SBrick?

viewController.updateActuator = { channelValue, powerValue in
    let channel = SBrick.Channel(rawValue: UInt8(channelValue)) ?? .a
    let power = UInt8(abs(powerValue))
    let direction: SBrick.Direction = powerValue > 0 ? .clockwise : .counterclockwise
    connectedSmartBrick?.updateDrive(channel: channel, power: power, direction: direction)
//    connectedSmartBrick?.updateQuickDrive(values: [(power, direction)])
}

let smartBricksManager = SmartBricksManager()
smartBricksManager.connectToNearestDevice() { smartBrick in
    switch smartBrick {
    case let sbrick as SBrick:
        connectedSmartBrick = sbrick
        let name = sbrick.peripheral.name ?? "<unknown>"
        viewController.connectionState = .connected(name)
    default:
        print("No smart brick found")
    }
}
