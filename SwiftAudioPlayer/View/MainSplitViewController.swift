//
//  MainSplitViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

class SidebarSplitItem: NSSplitViewItem {
    
    override var isCollapsed: Bool {
        didSet {
            print("did toggle sidebar")
        }
    }
}

class MainSplitViewController: NSSplitViewController {

    let player = Player()
    
    let sidebarVC: SidebarViewController = {
        let vc = SidebarViewController()
        return vc
    }()
    
    let tracksVC: ContentViewController = {
        let vc = ContentViewController()
        return vc
    }()
    
    lazy var sidebarSplitItem: SidebarSplitItem = {
        let item = SidebarSplitItem(sidebarWithViewController: self.sidebarVC)
        return item
    }()
    
    var viewModel: ViewModelProtocol? {
        didSet {
            print("appState changed")
        }
    }
    
    var uiState: UIState?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSplitView()
        setupUI()
    }
        
    func toggleSidebar(_ sender: Any?, withCompletionHandler completion:@escaping () -> Void) {
        toggleSidebar(sender)
        view.setNeedsDisplay(view.frame)
        completion()
    }

    private func setupSplitView() {
        addSplitViewItem(sidebarSplitItem)
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: tracksVC))
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        viewModel.uiState.bindAndFire { [unowned self] in
            self.uiState = $0
            print("setupUI")
        }
    }
    
}

