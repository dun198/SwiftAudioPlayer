//
//  ProgressBarView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol ProgressBarDelegate {
    func updateDurationLabel()
    func updateCurrentPositionLabel()
    func seek()
}

class ProgressBarView: NSView {
    
    var delegate: ProgressBarDelegate?
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 8
        stack.edgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
//        stack.setContentHuggingPriority(.required, for: .horizontal)
//        stack.setHuggingPriority(.required, for: .horizontal)
//        stack.setClippingResistancePriority(.required, for: .horizontal)
//        stack.setContentCompressionResistancePriority(.required, for: .horizontal)
//        stack.setClippingResistancePriority(.required, for: .vertical)
//        stack.setContentCompressionResistancePriority(.required, for: .vertical)


        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let progressSlider: NSSlider = {
        let slider = NSSlider()
        slider.controlSize = NSControl.ControlSize.mini
        return slider
    }()
    
    let currentPositionLabel: Label = {
        let label = Label()
        label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: NSControl.ControlSize.mini))
        label.stringValue = "00:00"
        return label
    }()
    
    let durationLabel: Label = {
        let label = Label()
        label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: NSControl.ControlSize.mini))
        label.stringValue = "00:00"
        return label
    }()
    
    lazy var leadingViews: [NSView] = [currentPositionLabel]
    lazy var centerViews: [NSView] = [progressSlider]
    lazy var trailingViews: [NSView] = [durationLabel]
    
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
        
        leadingViews.forEach {
            stackView.addView($0, in: .leading)
            stackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: $0)
        }
        
        centerViews.forEach {
            stackView.addView($0, in: .center)
        }
        
        trailingViews.forEach {
            stackView.addView($0, in: .trailing)
            stackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: $0)

        }
    }
}
