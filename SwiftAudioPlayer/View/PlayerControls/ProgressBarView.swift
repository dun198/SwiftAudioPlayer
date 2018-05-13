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
  private(set) var isInSeekMode = false
  
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
    slider.action = #selector(handleSeek)
    return slider
  }()
  
  let currentPositionLabel: Label = {
    let label = Label()
    label.textColor = NSColor.controlTextColor
    label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: NSControl.ControlSize.mini))
    label.stringValue = "00:00"
    return label
  }()
  
  let durationLabel: Label = {
    let label = Label()
    label.textColor = NSColor.controlTextColor
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
  
  private func setupObserver() {
    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    
    player.addPeriodicObserver(forInterval: interval) {
      [weak self] time in
      guard let strongSelf = self, !strongSelf.isInSeekMode else { return }
      guard let duration = strongSelf.player.currentTrack?.duration else { return }
      strongSelf.currentPositionLabel.stringValue = time.durationText
      strongSelf.progressSlider.doubleValue = time.seconds/duration.seconds
    }
  }
  
  @objc func handleSeek() {
    isInSeekMode = true
    defer { isInSeekMode = false }
    guard let duration = player.currentTrack?.duration else { return }
    let totalSeconds = CMTimeGetSeconds(duration)
    let seekValue = Float64(progressSlider.floatValue) * totalSeconds
    let seekTime = CMTime(value: Int64(seekValue), timescale: 1)
    player.seek(to: seekTime)
  }
}
