import Cocoa
import SmartBricks
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true

//:

class ViewController : NSViewController {
    override func loadView() {
        let stackView = NSStackView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        self.view = stackView
        
        let button0 = NSButton(title: "title0", target: nil, action: nil)
        stackView.addView(button0, in:.center)
        let button1 = NSButton(title: "title1", target: nil, action: nil)
        stackView.addView(button1, in:.center)
        let slider = NSSlider()
        stackView.addView(slider, in:.center)
    }
}
let viewController = ViewController()
PlaygroundPage.current.liveView = viewController

//let smartBricksManager = SmartBricksManager()
//smartBricksManager.connectToNearestDevice() { smartBrick in
//    switch smartBrick {
//    case let sbrick as SBrick:
//        print("Connected to \(sbrick.peripheral.name ?? "<unknown>") \(sbrick.peripheral.state)")
//        sbrick.updateQuickDrive(value0: 255, direction0: .clockwise)
//    case let sbrick as SBrickPlus:
//        print("Connected to \(sbrick.peripheral.name ?? "<unknown>") \(sbrick.peripheral.state)")
//        sbrick.updateQuickDrive(value0: 255, direction0: .clockwise)
//        sbrick.retrieveSensorValue(channel: .a)
//    default:
//        print("No smart brick found")
//    }
//}
