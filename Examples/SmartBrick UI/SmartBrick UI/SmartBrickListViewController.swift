//
//  SmartBrickListViewController.swift
//  SmartBrick UI
//
//  Created by Claus Höfele on 01.05.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa

private struct Item {
    var name: String
}

private struct Group {
    var name: String
    var items: [Item]
}

class SmartBrickListViewController: NSViewController {
    @IBOutlet private weak var outlineView: NSOutlineView!
    
    fileprivate var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let group = Group(name: "DEVICES", items: [Item(name: "Device 1"), Item(name: "Device 2")])
        groups.append(group)
        outlineView.expandItem(nil, expandChildren: true)
    }
}

extension SmartBrickListViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? Group {
            return item.items[index]
        } else {
            return groups[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is Group
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? Group {
            return item.items.count
        } else {
            return groups.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item is Group
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return !(item is Group)
    }
}

extension SmartBrickListViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        
        if let item = item as? Group {
            view = outlineView.make(withIdentifier: "HeaderCellID", owner: self) as? NSTableCellView
            view?.textField?.stringValue = item.name
        } else if let item = item as? Item {
            view = outlineView.make(withIdentifier: "DeviceCellID", owner: self) as? NSTableCellView
            view?.textField?.stringValue = item.name
        }
        
        return view
    }
}
