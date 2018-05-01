//
//  ToolbarView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 30.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol ContentToolbarDelegate {
    func toggleSidebar()
}

class ToolbarView: NSView {
    
    var delegate: ContentToolbarDelegate?
    
    let spacerForWindowButtons: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.isHidden = true
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
        searchField.controlSize = NSControl.ControlSize.regular
        searchField.refusesFirstResponder = true
        searchField.setContentHuggingPriority(.required, for: .horizontal)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.widthAnchor.constraint(lessThanOrEqualToConstant: 144).isActive = true
        searchField.delegate = self
        return searchField
    }()
    
    lazy var toggleSidebarButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarSidebarTemplate)!
        let button = ImageButton(image: image, width: 26, height: 26)
        button.bezelStyle = NSButton.BezelStyle.texturedRounded
        button.isBordered = true
        button.target = self
        button.action = #selector(toggleSidebar)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    @objc private func toggleSidebar() {
        print("pressed toggleToolbarButton")
        delegate?.toggleSidebar()
    }
}

extension ToolbarView: NSSearchFieldDelegate {
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        print("didStartSearching")
    }
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        print("didEndSearching")
    }
}

extension ToolbarView: CollapseSplitViewDelegate {
    func splitView(didCollapse: Bool) {
        print("didCollapse: ", didCollapse)
        if didCollapse {
            spacerForWindowButtons.isHidden = false
        } else {
            spacerForWindowButtons.isHidden = true
        }
    }
}
