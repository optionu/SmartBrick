//
//  SmartBrickListViewController.swift
//  SmartBrick UI
//
//  Created by Claus Höfele on 01.05.17.
//  Copyright © 2017 Claus Höfele. All rights reserved.
//

import Cocoa
import SmartBrick

// Item is required as a wrapper around SmartBrick because NSOutlineView tests its
// items for identity and for this reason requires a class object.
private class Item: Equatable {
    var smartBrickDescription: SmartBrickDescription
    
    init(smartBrickDescription: SmartBrickDescription) {
        self.smartBrickDescription = smartBrickDescription
    }

    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.smartBrickDescription.identifier == rhs.smartBrickDescription.identifier
    }
}

private class Group {
    var name: String
    var items: [Item]

    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
}

protocol SmartBrickListViewControllerDelegate: class {
    func smartBrickListViewController(_ smartBrickListViewController: SmartBrickListViewController, didSelect smartBrickDescription: SmartBrickDescription)
}

class SmartBrickListViewController: NSViewController {
    weak var delegate: SmartBrickListViewControllerDelegate?
    
    @IBOutlet private weak var outlineView: NSOutlineView!
    fileprivate var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups.append(Group(name: "DEVICES", items: []))
        outlineView.expandItem(nil, expandChildren: true)
    }
    
    func updateList(with smartBrickDescription: SmartBrickDescription) {
        let item = Item(smartBrickDescription: smartBrickDescription)
        
        if let index = groups[0].items.index(where: {$0 == item}) {
            // Updated device
            let item = groups[0].items[index]
            item.smartBrickDescription = smartBrickDescription
            outlineView.reloadItem(item)
        } else {
            // New device
            groups[0].items.append(item)
            outlineView.insertItems(at: IndexSet(integer: groups[0].items.count - 1), inParent: groups[0], withAnimation: [])
        }
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
        
        if let group = item as? Group {
            view = outlineView.make(withIdentifier: "HeaderCellID", owner: self) as? NSTableCellView
            view?.textField?.stringValue = group.name
        } else if let item = item as? Item {
            view = outlineView.make(withIdentifier: "DeviceCellID", owner: self) as? NSTableCellView
            view?.textField?.stringValue = item.smartBrickDescription.name ?? "<unknown>"
        }
        
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView,
            let item = outlineView.item(atRow: outlineView.selectedRow) as? Item else {
            return
        }
        
        delegate?.smartBrickListViewController(self, didSelect: item.smartBrickDescription)
    }
}
