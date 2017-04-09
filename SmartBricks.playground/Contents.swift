import Cocoa
import SmartBricks
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let smartBricksManager = SmartBricksManager()
smartBricksManager.connectToNearestDevice() { smartBrick in
    if let smartBrick = smartBrick {
        print("Connected to \(smartBrick.name ?? "<unknown>")")
    } else {
        print("No smart brick found")
    }
}
