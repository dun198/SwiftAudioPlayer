//
//  TracksViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ContentViewController: NSViewController {
    
    lazy var playerBox: PlayerBox = {
        let view = PlayerBox()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(playerBox)
        
        let leadingConstraint = playerBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        leadingConstraint.priority = .defaultLow
        leadingConstraint.isActive = true
        playerBox.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16).isActive = true
        playerBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        //playerBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        playerBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        playerBox.widthAnchor.constraint(lessThanOrEqualToConstant: 480).isActive = true
        
    }
    
}
