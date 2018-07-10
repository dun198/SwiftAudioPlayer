//
//  ProgressBarView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa
import AVFoundation

class ProgressBarView: NSView {
  
  private let player = Player.shared
  private let notificationCenter = NotificationCenter.default
  
  private let stackView: NSStackView = {
    let stack = NSStackView()
    stack.orientation = .horizontal
    stack.spacing = 8
    stack.edgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private lazy var progressSlider: NSSlider = {
    let slider = NSSlider()
    slider.controlSize = NSControl.ControlSize.mini
    slider.target = self
    slider.sendAction(on: [.leftMouseDown, .leftMouseDragged])
    slider.action = #selector(handleSliderChange)
    return slider
  }()
  
  private let currentPositionLabel: Label = {
    let label = Label()
    label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: NSControl.ControlSize.mini))
    label.stringValue = "00:00"
    return label
  }()
  
  private let durationLabel: Label = {
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
    setupObserver()
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
    player.percentProgress.bindAndFire { [unowned self] (value) in
      guard let window = self.window, window.occlusionState.contains(.visible) else { return }
      self.progressSlider.doubleValue = value
    }
    player.playbackPosition.bindAndFire { [unowned self] (value) in
      guard let window = self.window, window.occlusionState.contains(.visible) else { return }
      self.currentPositionLabel.stringValue = value.durationText
    }
  }

  private func setupObserver() {
    notificationCenter.addObserver(self, selector: #selector(handleCurrentTrackChanged(_:)), name: .currentTrackChanged, object: nil)
  }
  
  private func seekToSliderPosition() {
    guard let duration = player.currentTrack?.duration else { return }
    let seekValue = progressSlider.doubleValue * duration
    let seekTime = CMTime(seconds: seekValue, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    player.seek(to: seekTime)
  }
  
  @objc private func handleSliderChange() {
    seekToSliderPosition()
  }
  
  @objc private func handleCurrentTrackChanged(_ notification: NSNotification) {
    guard let track = notification.object as? Track else { return }
    durationLabel.stringValue = track.duration.durationText
  }
}
