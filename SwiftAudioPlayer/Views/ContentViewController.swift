//
//  TracksViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

fileprivate let REORDER_TRACKS_PASTEBOARD_TYPE = "com.dunkeeel.SwiftAudioPlayer.TrackItem"

// MARK: Constants
fileprivate let shouldLoadMusicDirectory = false

// MARK: UI Constants
fileprivate let toolbarHeight: CGFloat = 36

fileprivate let playerControlsPaddingSide: CGFloat = 12
fileprivate let playerControlsPaddingBottom: CGFloat = 12
fileprivate let playerControlsMaxWidth: CGFloat = 464

fileprivate let nowPlayingMaxWidth: CGFloat = 500
fileprivate let nowPlayingPaddingTop: CGFloat = toolbarHeight + 8
fileprivate let nowPlayingPaddingBottom: CGFloat = 8

fileprivate let flowLayoutBottomInset: CGFloat = 80 + 66
fileprivate let flowLayoutTopInset: CGFloat = toolbarHeight + 8

fileprivate let showHideInterfaceThreshold: CGFloat = 5
fileprivate let showHideInterfaceAnimationDuration: TimeInterval = 0.4

// MARK: CollectionViewItem Identifiers
extension NSUserInterfaceItemIdentifier {
  static let playlistHeaderItem = NSUserInterfaceItemIdentifier("PlaylistHeaderItem")
  static let playlistTrackItem = NSUserInterfaceItemIdentifier("PlaylistTrackItem")
}

// MARK: - ContentViewController
class ContentViewController: NSViewController {
  
  private let player = Player.shared
  private let notificationCenter = NotificationCenter.default
  private var tracks: [Track] = [Track]()
  private var itemsForDraggingSession: Set<IndexPath> = []
  
  lazy var fadingControls: [NSView] = {
    var views: [NSView] = [playerControlsView, nowPlayingInfoView]
    if let toolbar = NSApp.mainWindow?.toolbar {
      toolbar.visibleItems?.compactMap{$0.view}.forEach{views.append($0)}
    }
    return views
  }()
  
  lazy var flowLayout: SingleColumnFlowLayout = {
    let layout = SingleColumnFlowLayout()
    layout.itemSize.height = 21
    layout.sectionInset = NSEdgeInsets(top: flowLayoutTopInset, left: 8, bottom: flowLayoutBottomInset, right: 8)
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 8
    return layout
  }()
  
  lazy var collectionView: NSCollectionView = {
    let cv = NSCollectionView()
    cv.dataSource = self
    cv.delegate = self
    cv.collectionViewLayout = flowLayout
    if #available(OSX 10.14, *) {
    } else {
      cv.backgroundColors = [.clear]
    }
    cv.isSelectable = true
    cv.allowsMultipleSelection = true
    cv.registerForDraggedTypes([NSPasteboard.PasteboardType(REORDER_TRACKS_PASTEBOARD_TYPE)])
    cv.setDraggingSourceOperationMask(.move, forLocal: true)
    
    // register collectionView items
    cv.register(ContentHeaderItem.self, forItemWithIdentifier: .playlistHeaderItem)
    cv.register(TrackItem.self, forItemWithIdentifier: .playlistTrackItem)
    return cv
  }()
  
  lazy var scrollView: CollectionScrollView = {
    let sv = CollectionScrollView()
    sv.documentView = collectionView
    sv.translatesAutoresizingMaskIntoConstraints = false
    // hide vertical scroller
    sv.hasVerticalScroller = true
    sv.verticalScroller?.alphaValue = 0
    sv.delegate = self
    return sv
  }()
  
  lazy var playerControlsView: PlayerControlsView = {
    let view = PlayerControlsView()
    view.cornerRadius = 6
    view.translatesAutoresizingMaskIntoConstraints = false
    view.playbackControlsView.playbackControlsDelegate = self
    return view
  }()
  
  lazy var nowPlayingInfoView: NowPlayingInfoView = {
    let view = NowPlayingInfoView()
    view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func loadView() {
    view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupObserver()
    
    if shouldLoadMusicDirectory {
      loadFilesFromMusicDirectory()
    }
  }
  
  private func setupViews() {
    view.addSubview(scrollView)
    view.addSubview(playerControlsView)
    view.addSubview(nowPlayingInfoView)
    
    scrollView.fill(to: self.view)
    
    playerControlsView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor, constant: -playerControlsPaddingBottom)
      .isActive = true
    playerControlsView.rightAnchor
      .constraint(equalTo: view.rightAnchor, constant: -playerControlsPaddingSide)
      .isActive = true
    playerControlsView.leftAnchor
      .constraint(greaterThanOrEqualTo: view.leftAnchor, constant: playerControlsPaddingSide)
      .isActive = true
    let playerControlsWidthConstraint = playerControlsView.widthAnchor
      .constraint(equalToConstant: playerControlsMaxWidth)
    playerControlsWidthConstraint.priority = NSLayoutConstraint.Priority.defaultLow
    playerControlsWidthConstraint.isActive = true
    
    nowPlayingInfoView.rightAnchor
      .constraint(equalTo: playerControlsView.rightAnchor)
      .isActive = true
    nowPlayingInfoView.leftAnchor
      .constraint(greaterThanOrEqualTo: view.leftAnchor, constant: playerControlsPaddingSide)
      .isActive = true
    nowPlayingInfoView.bottomAnchor
      .constraint(equalTo: playerControlsView.topAnchor, constant: -nowPlayingPaddingBottom)
      .isActive = true
    nowPlayingInfoView.topAnchor
      .constraint(greaterThanOrEqualTo: view.topAnchor, constant: nowPlayingPaddingTop)
      .isActive = true
    nowPlayingInfoView.widthAnchor
      .constraint(lessThanOrEqualToConstant: nowPlayingMaxWidth)
      .isActive = true
  }
  
  private func setupObserver() {
    // observe if video plays/pauses
    player.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    notificationCenter.addObserver(self, selector: #selector(next(sender:)), name: .playNextTrack, object: nil)
    notificationCenter.addObserver(self, selector: #selector(prev(sender:)), name: .playPreviousTrack, object: nil)
  }
  
  func showControls() {
    setViewState(to: .visible, for: fadingControls)
  }
  
  func fadeControls() {
    guard UserDefaults.standard.bool(forKey: Preferences.Key.fadeControlsWhenScrolling.rawValue) == true else { return }
    setViewState(to: .hidden, for: fadingControls)
  }
  
  private func setViewState(to state: Visibility, for views: [NSView]) {
    let alphaValue: CGFloat = state == .visible ? 1 : CGFloat(UserDefaults.standard.float(forKey: Preferences.Key.controlsVisibility.rawValue))
    NSAnimationContext.runAnimationGroup({ (context) in
      context.duration = showHideInterfaceAnimationDuration
      context.timingFunction = CAMediaTimingFunction(name: .easeOut)
      for view in views {
        view.animator().alphaValue = alphaValue
      }
    })
  }
  
  private func loadFilesFromMusicDirectory() {
    let musicDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Music")
    let playableFiles = TrackLoader.getPlayableFiles(in: [musicDirectory])
    playableFiles.forEach { tracks.append(Track($0)) }
    self.collectionView.reloadData()
  }
  
  override func mouseExited(with event: NSEvent) {
    super.mouseExited(with: event)
  }
  
  override func mouseEntered(with event: NSEvent) {
    super.mouseEntered(with: event)
  }
}

// MARK: - NSCollectionViewDataSource
extension ContentViewController: NSCollectionViewDataSource {
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return tracks.count
  }
  
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(withIdentifier: .playlistTrackItem, for: indexPath) as! TrackItem
    cell.track = tracks[indexPath.item]
    cell.index = indexPath.item
    cell.delegate = self
    return cell
  }
}

// MARK: - NSCollectionViewDelegate
extension ContentViewController: NSCollectionViewDelegate {
  
  func collectionView(_ collectionView: NSCollectionView, didChangeItemsAt indexPaths: Set<IndexPath>, to highlightState: NSCollectionViewItem.HighlightState) {
    if highlightState == NSCollectionViewItem.HighlightState.forSelection {
    }
  }
  
  func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
    guard let draggingTypes = draggingInfo.draggingPasteboard.types else {
      print("invalid drop")
      return []
    }

    if draggingTypes.contains(NSPasteboard.PasteboardType(REORDER_TRACKS_PASTEBOARD_TYPE)) {
      if proposedDropOperation.pointee == NSCollectionView.DropOperation.on {
        proposedDropOperation.pointee = NSCollectionView.DropOperation.before
      }
      return NSDragOperation.move
    }
    
    print("invalid drop")
    return []
  }
  
  func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
    
    let dragIndexes = itemsForDraggingSession.map { $0.item }
    let offset = dragIndexes.filter { $0 < indexPath.item }.count
    let dropIndexPaths: Set = Set(dragIndexes.indices.map { IndexPath(item: $0 + indexPath.item - offset, section: 0) })
    
    let draggingTracks = tracks
      .enumerated()
      .filter { dragIndexes.contains($0.offset) }
      .map { $0.element }
    
    print("draggingTracks: ", draggingTracks.map { $0.filename })
    
    collectionView.deselectAll(nil)
    
    collectionView.animator().performBatchUpdates({
      tracks = tracks
        .enumerated()
        .filter { !dragIndexes.contains($0.offset) }
        .map { $0.element }
      
      tracks.insert(contentsOf: draggingTracks, at: indexPath.item - offset)
    }, completionHandler: { success in
      collectionView.reloadData()
      collectionView.selectItems(at: dropIndexPaths, scrollPosition: NSCollectionView.ScrollPosition.centeredHorizontally)
    })
    
    return true
  }
  
  func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, index: Int, dropOperation: NSCollectionView.DropOperation) -> Bool {
    print("drop")
    for i in 0..<itemsForDraggingSession.count {
      print(i)
    }
    
    for draggedItemIndexPath in itemsForDraggingSession {
      print( draggedItemIndexPath)
      collectionView.animator().moveItem(at: draggedItemIndexPath, to: (index <= draggedItemIndexPath.item) ? IndexPath(item: index, section: 0) : (IndexPath(item: index - 1, section: 0)))
    }
    return true
  }
  
  func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
    print("write items to pasteboard")
    let pbItem = NSPasteboardItem()
    if let trackItem = tracks[indexPath.item] as Track? {
      pbItem.setString(trackItem.file.absoluteString, forType: NSPasteboard.PasteboardType(REORDER_TRACKS_PASTEBOARD_TYPE))
      return pbItem;
    }
    return nil
  }
  
  func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
    print("beginn dragging session with:")
    itemsForDraggingSession = indexPaths
    print(itemsForDraggingSession)
  }
  
  func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
    print("ended dragging session")
    itemsForDraggingSession = []
  }
  
  func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
    return true
  }
}

// MARK: - NSCollectionViewDelegateFlowLayout
extension ContentViewController: NSCollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
    return flowLayout.itemSize
  }
}

// MARK: - ToolbarDelegate
extension ContentViewController {
  
  func toggleSidebar() {
    guard let splitVC = parent as? MainSplitViewController else { return }
    splitVC.toggleSidebar(nil)
  }
  
  func addTracks() {
    TrackLoader.loadFilesOrDirectory(title: "Open File or Folder", canChooseDir: true) { [weak self] (playableFiles) in
      DispatchQueue.main.async {
        playableFiles.forEach { self?.tracks.append(Track($0)) }
        self?.collectionView.reloadData()
      }
    }
  }
  
  func removeAllTracks() {
    tracks.removeAll()
    self.collectionView.reloadData()
  }
}

// MARK: - TrackItemDelegate
extension ContentViewController: TrackItemDelegate {
  
  func trackItemDoubleAction(_ trackItem: TrackItem) {
    guard let track = trackItem.track else { return }
    player.play(track)
  }
}

// MARK: - CollectionScrollViewDelegate
extension ContentViewController: CollectionScrollViewDelegate {
  
  func collectionViewWillScroll(with event: NSEvent) {
    let yVelocity = abs(event.scrollingDeltaY)
    if yVelocity >= showHideInterfaceThreshold {
      fadeControls()
    }
  }
  
  func collectionViewDidScroll(with event: NSEvent) {
  }
}

// MARK: - PlaybackControlsDelegate
extension ContentViewController: PlaybackControlsDelegate {
  
  @IBAction func playPause(sender: NSButton) {
    if player.isPlaying {
      player.pause()
    } else {
      guard let track = player.currentTrack else { return }
      player.play(track)
    }
  }
  
  @IBAction func next(sender: NSButton) {
    guard let currentTrack = player.currentTrack else { return }
    guard let nextTrackIndex = tracks.firstIndex(of: currentTrack)?.advanced(by: 1) else { return }
    guard nextTrackIndex < tracks.count else { return }
    let nextTrack = tracks[nextTrackIndex]
    player.play(nextTrack)
  }
  
  @IBAction func prev(sender: NSButton) {
    guard let currentTrack = player.currentTrack else { return }
    guard let prevTrackIndex = tracks.firstIndex(of: currentTrack)?.advanced(by: -1) else { return }
    guard prevTrackIndex >= 0 else { return }
    let prevTrack = tracks[prevTrackIndex]
    player.play(prevTrack)
  }

  @IBAction func showVolumeControl(sender: NSButton) {
    self.present(VolumePopoverViewController(), asPopoverRelativeTo: sender.bounds, of: sender, preferredEdge: .minY, behavior: .transient)
  }
}
