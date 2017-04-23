import Cocoa
import SmartBrick
import SmartBrickUI
import PlaygroundSupport

let bundle = Bundle(for: SmartBrickViewController.self)
let storyboard = NSStoryboard(name: "SmartBrick", bundle: bundle)
let viewController = storyboard.instantiateInitialController() as! SmartBrickViewController
PlaygroundPage.current.liveView = viewController

var connectedSmartBrick: SBrick?
let smartBricksManager = SmartBrickManager()
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

viewController.updateActuator = { portValue, powerValue in
//    let port = SBrickPort(rawValue: UInt8(portValue)) ?? .a
//    let motor = connectedSmartBrick?.motor(for: port)
//    let power = UInt8(abs(powerValue))
//    let direction: SBrickMotorDirection = powerValue > 0 ? .clockwise : .counterclockwise
//    motor?.drive(direction: direction, power: power)
    
//    let port = SBrickPort(rawValue: UInt8(portValue)) ?? .a
//    let quickDrive = connectedSmartBrick?.quickDrive(for: port)
//    let power = UInt8(abs(powerValue))
//    let direction: MotorDirection = powerValue > 0 ? .clockwise : .counterclockwise
//    quickDrive?.changePortMapping(port0: .a, port1: .a, port2: .a, port3: .a)
//    quickDrive?.drive(portValues: [(direction, power)])

    let port = SBrickPort(rawValue: UInt8(portValue)) ?? .a
    let motionSensor = connectedSmartBrick?.motionSensor(for: port)
    motionSensor?.retrieveDistance()
}
