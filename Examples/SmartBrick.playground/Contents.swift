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

viewController.updateActuator = { channelValue, powerValue in
    let channel = SBrickChannel(rawValue: UInt8(channelValue)) ?? .a
    let motor = connectedSmartBrick?.motor(for: channel)

    let power = UInt8(abs(powerValue))
    let direction: SBrickMotorDirection = powerValue > 0 ? .clockwise : .counterclockwise
    motor?.drive(direction: direction, power: power)
    
//    let channel = SBrickChannel(rawValue: UInt8(channelValue)) ?? .a
//    let quickDrive = connectedSmartBrick?.quickDrive(for: channel)
//    
//    let power = UInt8(abs(powerValue))
//    let direction: MotorDirection = powerValue > 0 ? .clockwise : .counterclockwise
//    quickDrive?.changeChannelMapping(channel0: .a, channel1: .a, channel2: .a, channel3: .a)
//    quickDrive?.drive(channelValues: [(direction, power)])

//    let channel = SBrickChannel(rawValue: UInt8(channelValue)) ?? .a
//    let motionSensor = connectedSmartBrick?.motionSensor(for: channel)
//    motionSensor?.test()
}
