import Cocoa
import SmartBricks
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let smartBricksManager = SmartBricksManager()
let smartBrick = smartBricksManager.connectToNearestDevice(timeout: 5) { smartBrick in
    if let smartBrick = smartBrick {
        print("Connected to \(smartBrick.name ?? "<unknown>")")
    } else {
        print("No smart brick found")
    }
}
