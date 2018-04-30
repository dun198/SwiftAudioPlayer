//
//  MainSplitViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol CollapseSplitViewDelegate {
    func splitView(didCollapse: Bool)
}

class CollapsibleSplitItem: NSSplitViewItem {
    
    var delegate: CollapseSplitViewDelegate?
    
    override var isCollapsed: Bool {
        didSet {
            print("toggle sidebar")
            delegate?.splitView(didCollapse: isCollapsed)
        }
    }
}

class MainSplitViewController: NSSplitViewController {

    let player = Player()
    
    let contentVC: ContentViewController = {
        let vc = ContentViewController()
        return vc
    }()
    
    let infoBarVC: SidebarViewController = {
        let vc = SidebarViewController()
        return vc
    }()
    
    lazy var sidebarSplitItem: CollapsibleSplitItem = {
        let vc = SidebarViewController()
        let item = CollapsibleSplitItem(sidebarWithViewController: vc)
        item.delegate = contentVC.toolbarView
        item.maximumThickness = 250
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
        addSplitViewItem(NSSplitViewItem(viewController: contentVC))
//        splitView.dividerStyle = NSSplitView.DividerStyle.init(rawValue: 0)!
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        viewModel.uiState.bindAndFire { [unowned self] in
            self.uiState = $0
            print("setupUI")
        }
    }
    
}

class CustomSidebarSplitViewItem: NSSplitViewItem {
    
    convenience init(withViewController viewController: NSViewController) {
        self.init(viewController: viewController)
        self.maximumThickness = 200
        self.minimumThickness = 200
        self.canCollapse = true
        self.isSpringLoaded = true
        self.collapseBehavior = NSSplitViewItem.CollapseBehavior.preferResizingSiblingsWithFixedSplitView
        self.holdingPriority = NSLayoutConstraint.Priority.init(rawValue: 10)
    }
    
}
