import Cocoa
import SmartBricks
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let smartBricksManager = SmartBricksManager()
smartBricksManager.connectToNearestDevice() { smartBrick in
    if let smartBrick = smartBrick {
        print("Connected to \(smartBrick.peripheral.name ?? "<unknown>") \(smartBrick.peripheral.state)")
    } else {
        print("No smart brick found")
    }
}
