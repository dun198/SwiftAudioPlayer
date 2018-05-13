//
//  PlayerControlsView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class PlayerControlsView: RoundedEffectView {
  
  // player controls
  lazy var playbackControlsView: PlaybackControlsView = {
    let view = PlaybackControlsView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // progress bar
  lazy var progressView: ProgressBarView = {
    let view = ProgressBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // now playing info
  lazy var nowPlayingView: OldNowPlayingView = {
    let view = OldNowPlayingView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupViews()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(progressView)
    addSubview(playbackControlsView)
    
    playbackControlsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
    playbackControlsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    playbackControlsView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
    playbackControlsView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -0).isActive = true
    
    progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
    progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
  }
  
  @objc func didChangePlayerStateToPlaying(track: Track) {
    print("playing: \(track.filename)")
  }
  
  @objc func didChangePlayerStateToPaused(track: Track) {
    print("paused: \(track.filename)")
  }
  
  @objc func didChangePlayerStateToIdle() {
    print("idle")
  }
}
