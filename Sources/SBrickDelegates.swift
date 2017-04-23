//
//  SBrickDelegates.swift
//  SmartBrick
//
//  Created by Claus Höfele on 23.04.17.
//  Copyright © 2017 SmartBricks. All rights reserved.
//

import Foundation

class SBrickDelegates {
    private(set) var delegates = [SBrickChannel: MulticastDelegate<SBrickDelegate>]()
    var registeredChannels: [SBrickChannel] {
        return Array(delegates.keys)
    }
    
    @discardableResult func register(_ delegate: SBrickDelegate, for channel: SBrickChannel) -> Bool {
        let channelDelegates = delegates[channel] ?? MulticastDelegate<SBrickDelegate>()
        channelDelegates.append(delegate)
        delegates[channel] = channelDelegates
        
        return true // has registered for new channel
    }
    
    func unregister(_ delegate: SBrickDelegate) {
    }
    
    func dispatch(_ sbrick: SBrick, didReceiveSensorValue value: UInt16, for channel: SBrickChannel) {
    }
}
