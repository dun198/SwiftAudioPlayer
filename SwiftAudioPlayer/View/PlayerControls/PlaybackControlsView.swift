//
//  PlaybackControlsView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol PlaybackControlsDelegate {
  func playPause(sender: Any)
  func next(sender: Any)
  func prev(sender: Any)
}

class PlaybackControlsView: NSStackView {
  
  let notificationCenter = NotificationCenter.default
  var playbackControlsDelegate: PlaybackControlsDelegate?
  
  lazy var playPauseButton: ImageButton = {
    let image = NSImage(named: NSImage.Name.touchBarPlayTemplate)
    let scaling = NSImageScaling.scaleProportionallyUpOrDown
    let button = ImageButton(image: image!, width: 40, height: 40, scaling: scaling)
    button.target = self
    button.action = #selector(handlePlayPause)
    return button
  }()
  
  lazy var prevButton: ImageButton = {
    let image = NSImage(named: NSImage.Name.touchBarSkipBackTemplate)
    let button = ImageButton(image: image!)
    button.target = self
    button.action = #selector(handlePrev)
    return button
  }()
  
  lazy var nextButton: ImageButton = {
    let image = NSImage(named: NSImage.Name.touchBarSkipAheadTemplate)
    let button = ImageButton(image: image!)
    button.target = self
    button.action = #selector(handleNext)
    return button
  }()
  
  lazy var shuffleButton: ImageButton = {
    let image = NSImage(named: NSImage.Name.touchBarShareTemplate)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    return button
  }()
  
  lazy var repeatButton: ImageButton = {
    let image = NSImage(named: NSImage.Name.touchBarRefreshTemplate)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    return button
  }()
  
  lazy var volumeButton: ImageButton = {
    let image = NSImage(named: NSImage.Name.touchBarAudioOutputVolumeHighTemplate)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    return button
  }()
  
  lazy var infoButton: ImageButton = {
    let image = NSImage(named: NSImage.Name.touchBarGetInfoTemplate)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    return button
  }()
  
  lazy var leadingViews: [NSView] = [
    shuffleButton,
    repeatButton,
    SpacerView(minSize: 16, maxSize: 64)
  ]
  lazy var centerViews: [NSView] = [
    prevButton,
    playPauseButton,
    nextButton
  ]
  lazy var trailingViews: [NSView] = [
    SpacerView(minSize: 16, maxSize: 64),
    volumeButton,
    infoButton
  ]
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupStackView()
    setupViews()
    setupObserver()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupStackView() {
    orientation = .horizontal
    spacing = 8
    edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    translatesAutoresizingMaskIntoConstraints = false
    setClippingResistancePriority(.defaultLow, for: .horizontal)
  }
  
  private func setupViews() {
    leadingViews.forEach {
      addView($0, in: .leading)
      setVisibilityPriority(NSStackView.VisibilityPriority.detachOnlyIfNecessary, for: $0)
    }
    centerViews.forEach {
      addView($0, in: .center)
      setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: $0)
    }
    trailingViews.forEach {
      addView($0, in: .trailing)
      setVisibilityPriority(NSStackView.VisibilityPriority.detachOnlyIfNecessary, for: $0)
    }
  }
  
  private func setupObserver() {
    notificationCenter.addObserver(self,
                                   selector: #selector(playbackDidStart),
                                   name: .playbackStarted,
                                   object: nil
    )
    notificationCenter.addObserver(self,
                                   selector: #selector(playbackDidPauseOrStop),
                                   name: .playbackPaused,
                                   object: nil
    )
    notificationCenter.addObserver(self,
                                   selector: #selector(playbackDidPauseOrStop),
                                   name: .playbackStopped,
                                   object: nil
    )
  }
  
  @objc private func playbackDidStart() {
    playPauseButton.image = NSImage(named: NSImage.Name.touchBarPauseTemplate)
  }
  
  @objc private func playbackDidPauseOrStop() {
    playPauseButton.image = NSImage(named: NSImage.Name.touchBarPlayTemplate)
  }
  
  @objc private func handlePlayPause() {
    playbackControlsDelegate?.playPause(sender: playPauseButton)
  }
  
  @objc private func handleNext() {
    playbackControlsDelegate?.next(sender: nextButton)
  }
  
  @objc private func handlePrev() {
    playbackControlsDelegate?.prev(sender: prevButton)
  }
}
