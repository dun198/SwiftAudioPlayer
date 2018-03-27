//
//  MediumTitlebarViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 26.03.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MediumTitlebarViewController: NSTitlebarAccessoryViewController {

    @IBOutlet weak var nowPlayingView: NSView!
    @IBOutlet weak var secondStackView: NSStackView!
    @IBOutlet weak var firstStackView: NSStackView!
    
    var viewModel: ViewModelProtocol? {
        didSet {
            print("appState changed")
        }
    }
    var uiState: UIState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func setupUI() {
        
        guard let viewModel = viewModel else { return }
        viewModel.uiState.bindAndFire { [unowned self] in
            self.uiState = $0
        }
        
    }
    
}
