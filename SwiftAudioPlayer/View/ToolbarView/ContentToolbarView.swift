//
//  ContentToolbarView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 30.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ContentToolbarView: NSView {
    
    let spacerForWindowButtons: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 8
        stack.edgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var searchField: NSSearchField = {
        let searchField = NSSearchField()
        searchField.focusRingType = NSFocusRingType.none
        searchField.refusesFirstResponder = true
        searchField.setContentHuggingPriority(.required, for: .horizontal)
        searchField.delegate = self
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.widthAnchor.constraint(lessThanOrEqualToConstant: 144).isActive = true
        return searchField
    }()
    
    let toggleSidebarButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarSidebarTemplate)!
        let button = ImageButton(
            image: image,
            size: NSSize(width: 22, height: 22)
        )
        return button
    }()
    
    lazy var leadingViews: [NSView] = [spacerForWindowButtons, toggleSidebarButton]
    lazy var centerViews: [NSView] = []
    lazy var trailingViews: [NSView] = [searchField]
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.fill(to: self)
        
        leadingViews.forEach { stackView.addView($0, in: .leading) }
        centerViews.forEach { stackView.addView($0, in: .center) }
        trailingViews.forEach { stackView.addView($0, in: .trailing) }
    }
}

extension ContentToolbarView: NSSearchFieldDelegate {
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        print("didStartSearching")
    }
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        print("didEndSearching")
    }
}

extension ContentToolbarView: CollapseSplitViewDelegate {
    func splitView(didCollapse: Bool) {
        print("didCollapse: ", didCollapse)
        if didCollapse {
            stackView.views(in: .leading).forEach { stackView.removeView($0) }
            leadingViews.forEach { stackView.addView($0, in: .leading) }
        } else {
            stackView.removeView(spacerForWindowButtons)
        }
    }
    
    
}
