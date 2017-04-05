import Cocoa
import SmartBricks
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true

//let smartBrickManager = SmartBrickManager()
//smartBrickManager.scanForDevices()

let userDefaults = UserDefaults()
userDefaults.set("test", forKey: "test")
userDefaults.string(forKey: "test")
