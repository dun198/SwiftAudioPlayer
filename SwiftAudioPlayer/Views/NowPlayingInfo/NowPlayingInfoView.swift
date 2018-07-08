//
//  NowPlayingInfoView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 04.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate let spacing: CGFloat = 8
fileprivate let cornerRadius: CGFloat = 4

class NowPlayingInfoView: NSView {
  
  private let notificationCenter = NotificationCenter.default
  
  var title: String? {
    didSet {
      titleView.text = title
    }
  }
  
  var artist: String? {
    didSet {
      artistView.text = artist
    }
  }
  
  private let stackView: NSStackView = {
    let stack = NSStackView()
    stack.orientation = .vertical
    stack.alignment = .right
    stack.spacing = spacing
    stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private let titleView: RoundedEffectViewLabel = {
    let view = RoundedEffectViewLabel()
    view.cornerRadius = cornerRadius
    view.label.usesSingleLineMode = true
    view.isHidden = true
    return view
  }()
  
  private let artistView: RoundedEffectViewLabel = {
    let view = RoundedEffectViewLabel()
    view.cornerRadius = cornerRadius
    view.label.usesSingleLineMode = true
    view.isHidden = true
    return view
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupViews()
    setupObserver()
  }
  
  // avoid click through
  override func mouseDown(with event: NSEvent) {
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(stackView)
    stackView.fill(to: self)
    stackView.addArrangedSubview(artistView)
    stackView.addArrangedSubview(titleView)
  }
  
  private func setupObserver() {
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackStarted(_:)),
                                   name: .playbackStarted,
                                   object: nil
    )
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackStopped(_:)),
                                   name: .playbackStopped,
                                   object: nil
    )
  }
  
  @objc private func handlePlaybackStarted(_ notification: NSNotification) {
    updateNowPlayingInfo(for: notification.object as? Track)
  }
  
  @objc private func handlePlaybackStopped(_ notification: NSNotification) {
    updateNowPlayingInfo(for: notification.object as? Track)
  }
  
  private func updateNowPlayingInfo(for track: Track?) {
    if let track = track {
      showNowPlayingInfo(for: track)
    } else {
      hideNowPlayingInfo()
    }
  }
  
  private func showNowPlayingInfo(for track: Track) {
    titleView.isHidden = false
    if let artist = track.artist, let title = track.title {
      artistView.isHidden = false
      self.title = title
      self.artist = artist
    } else {
      artistView.isHidden = true
      self.title = track.filename
    }
  }
  
  private func hideNowPlayingInfo() {
    titleView.isHidden = true
    artistView.isHidden = true
  }
}
