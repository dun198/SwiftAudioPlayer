//
//  String.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation

extension String {
  var pathExtension: String {
    return (self as NSString).pathExtension
  }
}
