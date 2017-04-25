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
    var registeredChannels: Set<SBrickChannel> {
        return Set(delegates.keys.filter({ self.delegates[$0]?.count != 0 }))
    }
    
    @discardableResult func register(_ delegate: SBrickDelegate, for channel: SBrickChannel) -> Bool {
        let channelDelegates = delegates[channel] ?? MulticastDelegate<SBrickDelegate>()
        let hasRegisteredForNewChannel = channelDelegates.count == 0
        channelDelegates.append(delegate)
        delegates[channel] = channelDelegates
        
        return hasRegisteredForNewChannel
    }
    
    func unregister(_ delegate: SBrickDelegate) {
        for channelDelegates in delegates.values {
            channelDelegates.remove(delegate)
        }
    }
    
    func dispatch(_ sbrick: SBrick, didReceiveSensorValue value: UInt16, for channel: SBrickChannel) {
        delegates[channel]?.invoke { delegate in
            delegate.sbrick(sbrick, didReceiveSensorValue: value, for: channel)
        }
    }
}
