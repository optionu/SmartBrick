import Cocoa
import SmartBricks
import PlaygroundSupport

class ViewController : NSViewController {
    override func loadView() {
        let stackView = NSStackView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        stackView.orientation = .vertical
        stackView.edgeInsets = EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.view = stackView
        
        let firstRowStackView = NSStackView()
        stackView.addView(firstRowStackView, in:.top)
        let button0 = NSButton(title: "title0 asd", target: nil, action: nil)
        firstRowStackView.addView(button0, in:.center)
        let button1 = NSButton(title: "title1", target: nil, action: nil)
        firstRowStackView.addView(button1, in:.center)
        let slider = NSSlider(value: 0, minValue: 0, maxValue: 255, target: self, action: #selector(sliderChanged))
        slider.isContinuous = false
        firstRowStackView.addView(slider, in:.center)
    }
    
    func sliderChanged(sender: NSSlider) {
        print("\(connectedSmartBrick) \(sender.integerValue)")
        connectedSmartBrick?.updateQuickDrive(value0: UInt8(sender.integerValue), direction0: .clockwise)
    }
}
let viewController = ViewController()
PlaygroundPage.current.liveView = viewController

var connectedSmartBrick: SBrick?

let smartBricksManager = SmartBricksManager()
smartBricksManager.connectToNearestDevice() { smartBrick in
    switch smartBrick {
    case let sbrick as SBrick:
        print("Connected to SB \(sbrick.peripheral.name ?? "<unknown>") \(sbrick.peripheral.state)")
        connectedSmartBrick = sbrick
    default:
        print("No smart brick found")
    }
}
