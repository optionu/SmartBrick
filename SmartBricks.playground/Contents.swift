import Cocoa
import SmartBricks
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let nearestDeviceHelper = NearestDeviceHelper(timeout: 5)  { smartBrick in
    print("Connected to \(smartBrick?.name ?? "<unknown>")")
}
let smartBricksManager = SmartBricksManager()
smartBricksManager.delegate = nearestDeviceHelper
smartBricksManager.scanForDevices()