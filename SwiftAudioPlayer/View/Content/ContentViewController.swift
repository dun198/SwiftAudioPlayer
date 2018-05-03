//
//  TracksViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate let toolbarHeight: CGFloat = 36
fileprivate let playerPanelPadding: CGFloat = 16

fileprivate var tracks: [Track] = [Track]()

extension NSUserInterfaceItemIdentifier {
    static let headerViewItem = NSUserInterfaceItemIdentifier("HeaderViewItem")
    static let trackViewItem = NSUserInterfaceItemIdentifier("TrackViewItem")
}

class ContentViewController: NSViewController {
    
    let backgroundEffectView: NSVisualEffectView = {
        let view = NSVisualEffectView()
        view.material = NSVisualEffectView.Material.appearanceBased
        view.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        view.state = NSVisualEffectView.State.inactive
        return view
    }()
    
    lazy var flowLayout: CustomFlowLayout = {
        let layout = CustomFlowLayout()
        layout.itemSize.height = 20
        layout.sectionInset = NSEdgeInsets(top: toolbarHeight, left: 8, bottom: 80 + 16, right: 8)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }()
    
    lazy var collectionView: NSCollectionView = {
        let cv = NSCollectionView()
        cv.dataSource = self
        cv.delegate = self
        cv.collectionViewLayout = flowLayout
        cv.backgroundColors = [.clear]
        cv.isSelectable = true
        // register collectionView items
        cv.register(HeaderViewItem.self, forItemWithIdentifier: .headerViewItem)
        cv.register(TrackViewItem.self, forItemWithIdentifier: .trackViewItem)
        return cv
    }()
    
    lazy var scrollView: NSScrollView = {
        let sv = NSScrollView()
        sv.documentView = collectionView
        sv.translatesAutoresizingMaskIntoConstraints = false
        // hide vertical scroller
        sv.hasVerticalScroller = true
        sv.verticalScroller?.alphaValue = 0
        return sv
    }()
    
    lazy var toolbarView: ToolbarView = {
        let view = ToolbarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var playerBox: PlayerPanel = {
        let view = PlayerPanel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let topGradientView: NSView = {
//        let view = GradientView()
//        view.topGradientColor = NSColor.black
//        view.topColorLocation = 1.4
//        return view
//    }()
//
//    let bottomGradientView: GradientView = {
//        let view = GradientView()
//        view.bottomGradientColor = NSColor.black
//        view.bottomColorLocation = -0.4
//        return view
//    }()
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadFilesForHomeDirectory()
    }
    
    private func loadFilesForHomeDirectory() {
        let musicDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Music")
        let playableFiles = TrackLoader.getPlayableFiles(in: [musicDirectory])
        playableFiles.forEach { tracks.append(Track($0)) }
        self.collectionView.reloadData()
    }
    
    fileprivate func setupViews() {
        view.addSubview(backgroundEffectView)
        view.addSubview(scrollView)
        view.addSubview(playerBox)
        view.addSubview(toolbarView)
//        view.addSubview(topGradientView, positioned: NSWindow.OrderingMode.above, relativeTo: scrollView)
//        view.addSubview(bottomGradientView, positioned: NSWindow.OrderingMode.above, relativeTo: scrollView)

        backgroundEffectView.fill(to: self.view)
        scrollView.fill(to: self.view)
        
        toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        toolbarView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
        
        playerBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -playerPanelPadding).isActive = true
        playerBox.leftAnchor.constraint(equalTo: view.leftAnchor, constant: playerPanelPadding).isActive = true
        playerBox.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 8 + toolbarHeight).isActive = true

//        topGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        topGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        topGradientView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        topGradientView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
//
//        bottomGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        bottomGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        bottomGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        bottomGradientView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
    }
}

extension ContentViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: .trackViewItem, for: indexPath) as! TrackViewItem
        cell.track = tracks[indexPath.item]
        cell.trackNumberLabel.stringValue = "\(indexPath.item) ."
        return cell
    }
}

extension ContentViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didChangeItemsAt indexPaths: Set<IndexPath>, to highlightState: NSCollectionViewItem.HighlightState) {
        if highlightState == NSCollectionViewItem.HighlightState.forSelection {
//            print("selected cell ", indexPaths)
        }
    }
}

extension ContentViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return flowLayout.itemSize
    }
}

extension ContentViewController: ToolbarDelegate {
    func toggleSidebar() {
        guard let splitVC = parent as? MainSplitViewController else { return }
        splitVC.toggleSidebar(nil)
    }
    
    func addTracks() {
        TrackLoader.openFileOrFolder(title: "Open File or Folder", canChooseDir: true) { (selectedURLs) in
            let playableFiles = TrackLoader.getPlayableFiles(in: selectedURLs)
            playableFiles.forEach { tracks.append(Track($0)) }
            self.collectionView.reloadData()
        }
    }
    
    func removeAllTracks() {
        tracks.removeAll()
        self.collectionView.reloadData()
    }
}
