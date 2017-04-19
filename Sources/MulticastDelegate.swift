//
//  MulticastDelegate.swift
//  MulticastDelegateDemo
//
//  Created by Joao Nunes on 28/12/15.
//  Copyright © 2015 Joao Nunes. All rights reserved.
//

// Based on https://github.com/jonasman/MulticastDelegate/blob/master/Sources/MulticastDelegate.swift

import Foundation

class MulticastDelegate<T> {
    private let delegates = NSHashTable<AnyObject>.weakObjects()
    var count: Int {
        return delegates.allObjects.count
    }
    
    func append(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func remove(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }
    
    func invoke(_ invocation: (T) -> ()) {
        for delegate in delegates.allObjects {
            invocation(delegate as! T)
        }
    }
    
    func contains(_ delegate: T) -> Bool {
        return delegates.contains(delegate as AnyObject)
    }
}
