import Cocoa
import SmartBricks
import SmartBricksUI
import PlaygroundSupport

let bundle = Bundle(for: SmartBricksViewController.self)
let storyboard = NSStoryboard(name: "SmartBricks", bundle: bundle)
let viewController = storyboard.instantiateInitialController() as! SmartBricksViewController
PlaygroundPage.current.liveView = viewController

var connectedSmartBrick: SBrick?

viewController.sliderChanged = { value in
    connectedSmartBrick?.updateQuickDrive(value0: UInt8(value), direction0: .clockwise)
}

viewController.stop = {
    connectedSmartBrick?.updateQuickDrive(value0: 0, direction0: .clockwise)
}

let smartBricksManager = SmartBricksManager()
smartBricksManager.connectToNearestDevice() { smartBrick in
    switch smartBrick {
    case let sbrick as SBrick:
        print("Connected to SB \(sbrick.peripheral.name ?? "<unknown>") \(sbrick.peripheral.state)")
        connectedSmartBrick = sbrick
    default:
        print("No smart brick found")
    }
}
