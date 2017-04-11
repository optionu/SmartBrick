import Cocoa
import SmartBricks
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let smartBricksManager = SmartBricksManager()
smartBricksManager.connectToNearestDevice() { smartBrick in
    switch smartBrick {
    case let sbrick as SBrick:
        print("Connected to \(sbrick.peripheral.name ?? "<unknown>") \(sbrick.peripheral.state)")
        sbrick.updateQuickDrive(value0: 255, direction0: .clockwise)
    case let sbrick as SBrickPlus:
        print("Connected to \(sbrick.peripheral.name ?? "<unknown>") \(sbrick.peripheral.state)")
        sbrick.updateQuickDrive(value0: 255, direction0: .clockwise)
        sbrick.retrieveSensorValue(channel: .a)
    default:
        print("No smart brick found")
    }
}
