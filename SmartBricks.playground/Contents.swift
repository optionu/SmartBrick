import Cocoa
import SmartBricks
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true

//let smartBrickManager = SmartBrickManager()
//smartBrickManager.scanForDevices()

let userDefaults = UserDefaults()
userDefaults.set("test", forKey: "test")
userDefaults.string(forKey: "test")

// https://www.raywenderlich.com/148569/unsafe-swift
// https://realm.io/news/goto-mike-ash-exploring-swift-memory-layout/

//func readData<T: Integer>(fromData data: Data, start: Int) -> T {
//    let bits = data.withUnsafeBytes({(bytePointer: UnsafePointer<UInt8>) -> T in
//        bytePointer.advanced(by: start).withMemoryRebound(to: T.self, capacity: MemoryLayout<T>.size) { pointer in
//            return pointer.pointee
//        }
//    })
//    return T(integerLiteral: bits)
//}

//let data = Data(bytes: [0x98, 0x01,
//                        0x06, 0x00, 0x00, 0x0b, 0x00, 0x0b, 0x12,
//                        0x07, 0x02, 0xf3, 0x43, 0x3d, 0x19, 0xfd, 0xc8,
//                        0x02, 0x03, 0x00,
//                        0x05, 0x06, 0xe8, 0x4b, 0xa9, 0x5b])
//let i: UInt16 = readData(fromData: data, start: 0)

//let i = Int(bitPattern: UnsafeMutablePointer<U>?)
//let u = UInt(bigEndian: <#T##UInt#>)
//let i = Int(bigEndian: <#T##Int#>)
