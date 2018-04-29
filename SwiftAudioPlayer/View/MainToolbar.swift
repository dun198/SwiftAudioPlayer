//
//  MainToolbar.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MainToolbar: NSToolbar {
    override init(identifier: NSToolbar.Identifier) {
        super.init(identifier: identifier)
        
        // Make sure that tracking is enabled when the toolbar is completed
        DispatchQueue.main.async {
            self.trackSplitViewForFirstFlexibleToolbarItem()
        }
    }
}

extension MainToolbar: NSToolbarDelegate {
    
    func toolbarWillAddItem(_ notification: Notification) {
        print("will add item")
        // Make sure that tracking is evaluated only after the item was added
        DispatchQueue.main.async {
            self.trackSplitViewForFirstFlexibleToolbarItem()
        }
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        print("removed item")
        trackSplitViewForFirstFlexibleToolbarItem()
    }
    
    /// - Warning: This is a private Apple method and may break in the future.
    func toolbarDidReorderItem(_ notification: Notification) {
        print("reordered item")
        trackSplitViewForFirstFlexibleToolbarItem()
    }
    
    /// - Warning: This method uses private Apple methods that may break in the future.
    fileprivate func trackSplitViewForFirstFlexibleToolbarItem() {
        guard let splitView = (NSApplication.shared.mainWindow?.contentViewController as? NSSplitViewController)?.splitView else {
            return
        }
        
        // Add tracking to the first flexible space and remove it from the group
        if let firstFlexibleToolbarItem = items.first, firstFlexibleToolbarItem.itemIdentifier == NSToolbarItem.Identifier.flexibleSpace {
            _ = firstFlexibleToolbarItem.perform(Selector(("setTrackedSplitView:")), with: splitView)
            removeItem(at: 0)
            //items.removeFirst()
        }
        
        // Remove tracking from other flexible spaces
        for flexibleToolbarItem in items.filter({ $0.itemIdentifier == NSToolbarItem.Identifier.flexibleSpace }) {
            _ = flexibleToolbarItem.perform(Selector(("setTrackedSplitView:")), with: nil)
        }
    }
    
    func didToggleSidebar() {
        trackSplitViewForFirstFlexibleToolbarItem()
    }
}
