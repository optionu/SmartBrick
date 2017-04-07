import Cocoa
import SmartBricks
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let smartBricksManager = SmartBricksManager()
smartBricksManager.scanForDevices()

class Delegate: SmartBricksManagerDelegate {
    func smartBricksManager(_ smartBricksManager: SmartBricksManager, didDiscover smartBrick: SmartBrick) {
        print("Found \(smartBrick.name ?? "<unknown>") \(smartBrick.identifier)")
    }
}

let userDefaults = UserDefaults()
userDefaults.set("test", forKey: "test")
userDefaults.string(forKey: "test")
