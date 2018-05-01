//
//  TrackViewItem.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol DoubleActionDelegate where Self:NSView {
    var doubleAction: Selector? { get set }
    var doubleActionTarget: Any? { get set }
    //func mouseDown(with event: NSEvent)
}

extension DoubleActionDelegate where Self:NSView {
    func mouseDown(with event: NSEvent) {
        if let doubleAction = doubleAction , event.clickCount == 2 {
            NSApp.sendAction(doubleAction, to: doubleActionTarget, from: self)
        }
        else {
            self.mouseDown(with: event)
        }
    }
}

class TrackViewItem: NSCollectionViewItem {
    
    var track: Track? = nil {
        didSet {
            print("setting up track")
            guard let track = track else { return }
            trackTitleLabel.stringValue = "\(track.artist!) - \(track.title!)"
            durationLabel.stringValue = track.duration
        }
    }
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 4
        stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        stack.setClippingResistancePriority(.required, for: .horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let trackArtistLabel: Label = {
        let label = Label()
        label.stringValue = " Artist"
        label.font = NSFont.systemFont(ofSize: 12)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.alignment = .left
        return label
    }()
    
    let trackTitleLabel: Label = {
        let label = Label()
        label.stringValue = " Super Long and awesome Track Title"
        label.font = NSFont.systemFont(ofSize: 12)
        label.alignment = .left
        return label
    }()
    
    let durationLabel: Label = {
        let label = Label()
        label.stringValue = "03:20"
        label.font = NSFont.systemFont(ofSize: 12)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.alignment = .center
        return label
    }()
    
    let trackNumberLabel: Label = {
        let label = Label()
        label.stringValue = ""
        label.font = NSFont.systemFont(ofSize: 8)
        label.textColor = .gray
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.alignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }()
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.fill(to: self.view)
        
        let leadingViews: [NSView] = [trackNumberLabel, trackTitleLabel]
        let centerViews: [NSView] = []
        let trailingViews: [NSView] = [durationLabel]
        
        leadingViews.forEach { stackView.addView($0, in: .leading) }
        centerViews.forEach { stackView.addView($0, in: .center) }
        trailingViews.forEach { stackView.addView($0, in: .trailing) }
    }
    
    
}
