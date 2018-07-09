//
//  ProgressBarView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ProgressBarView: NSView {
  
  private let player = Player.shared
  
  let stackView: NSStackView = {
    let stack = NSStackView()
    stack.orientation = .horizontal
    stack.spacing = 8
    stack.edgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  lazy var progressSlider: NSSlider = {
    let slider = NSSlider()
    slider.controlSize = NSControl.ControlSize.mini
    slider.target = self
    slider.action = #selector(handleSliderChange)
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
    setupBindings()
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
  
  private func setupBindings() {
    player.percentProgress.bindAndFire { [weak self] (value) in
      guard let window = self?.window, window.occlusionState.contains(.visible) else { return }
      self?.progressSlider.doubleValue = value
    }
    player.playbackPosition.bindAndFire { [weak self] (value) in
      guard let window = self?.window, window.occlusionState.contains(.visible) else { return }
      self?.currentPositionLabel.stringValue = value.durationText
    }
    player.currentTrack.bindAndFire { [weak self] (value) in
      self?.durationLabel.stringValue = value?.duration?.durationText ?? "--:--"
    }
  }

  private func seekToSliderPosition() {
    guard let duration = player.currentTrack.value?.duration else { return }
    let seekValue = progressSlider.doubleValue * duration
    player.seek(to: seekValue)
  }
  
  @objc private func handleSliderChange() {
    seekToSliderPosition()
  }
}
