//
//  TracksViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate let toolbarHeight: CGFloat = 40

extension NSUserInterfaceItemIdentifier {
    static let headerViewItem = NSUserInterfaceItemIdentifier("HeaderViewItem")
    static let trackViewItem = NSUserInterfaceItemIdentifier("TrackViewItem")
}

class ContentViewController: NSViewController {
    
    let backgroundEffectView: NSVisualEffectView = {
        let view = NSVisualEffectView()
        view.material = NSVisualEffectView.Material.titlebar
        view.state = .inactive
        return view
    }()
    
//    let scrollerBackgroundView: BackgroundView = {
//        let view = BackgroundView()
//        view.backgroundColor = NSColor.windowBackgroundColor
//        return view
//    }()
    
    var tracks: [Track] = [
        Track(filename: "01 A New Sensation (feat. Chris #2)", duration: "3:45", title: "A New Sensation (feat. Chris #2)", artist: "The Prosecution", album: "Words with Destiny", genre: "ska punk"),
        Track(filename: "02 The Last Shot", duration: "4:12", title: "The Last Shot", artist: "The Prosecution", album: "Words with Destiny", genre: "ska punk"),
        Track(filename: "03 Words of Peace", duration: "2:59", title: "Words of Peace", artist: "The Prosecution", album: "Words with Destiny", genre: "ska punk")
    ]
    
    func insertTestTracks(amount: Int) {
        let testTrack: Track = Track(filename: "Filename", duration: "0:00", title: "Title", artist: "Artist", album: "Album", genre: "Genre")
        for _ in 0..<amount {
            tracks.append(testTrack)
        }
    }
    
    lazy var flowLayout: CustomFlowLayout = {
        let layout = CustomFlowLayout()
        layout.itemSize.height = 24
        layout.sectionInset = NSEdgeInsets(top: toolbarHeight, left: 2, bottom: 72 + 8, right: 8)
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
    
//    let gradientView: NSView = {
//        let view = NSView()
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [CGColor.clear, CGColor.init(gray: 0.08, alpha: 1)]
//        gradientLayer.locations = [0, 0.4]
//        view.layer = gradientLayer
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    lazy var toolbarView: ToolbarView = {
        let view = ToolbarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playerBox: PlayerPanelView = {
        let view = PlayerPanelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertTestTracks(amount: 100)
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(backgroundEffectView)
//        view.addSubview(scrollerBackgroundView)
        view.addSubview(scrollView)
//        view.addSubview(gradientView)
        view.addSubview(toolbarView)
        view.addSubview(playerBox)
        
        backgroundEffectView.fill(to: self.view)
        
//        scrollerBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollerBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        scrollerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollerBackgroundView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        scrollView.fill(to: self.view)
        
//        gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        gradientView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        gradientView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
        
        toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        toolbarView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
        
        playerBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        playerBox.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 8).isActive = true
        playerBox.topAnchor.constraint(greaterThanOrEqualTo: toolbarView.bottomAnchor, constant: 0).isActive = true
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
    
}

extension ContentViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return flowLayout.itemSize
    }
}

extension ContentViewController: ContentToolbarDelegate {
    func toggleSidebar() {
        guard let splitVC = parent as? MainSplitViewController else { return }
        splitVC.toggleSidebar(nil)
    }
}
