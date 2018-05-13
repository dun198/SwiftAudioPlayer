//
//  CALayer.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

extension CALayer {
  
  func addShadowSublayer(withOffset offset: NSSize = .zero) {
    // shadow layer
    let shadowLayer = CALayer()
    shadowLayer.shadowColor = CGColor.black
    shadowLayer.shadowPath = CGPath(roundedRect: self.frame, cornerWidth: self.cornerRadius, cornerHeight: self.cornerRadius, transform: nil)
    shadowLayer.shadowOffset = CGSize(width: offset.width, height: offset.height)
    shadowLayer.shadowOpacity = 0.5
    shadowLayer.shadowRadius = 5
    self.addSublayer(shadowLayer)
  }
  
  func addShadow(withRadius radius: CGFloat = 1, opacity: Float = 1, offset: NSSize = .zero) {
    shadowColor = CGColor.black
    shadowOffset = CGSize(width: offset.width, height: offset.height)
    shadowOpacity = opacity
    shadowRadius = radius
  }
  
  func makeRounded(withCornerRadius cornerRadius: CGFloat) {
    let roundedLayer: CALayer = {
      let layer = CALayer()
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = true
      return layer
    }()
    self.addSublayer(roundedLayer)
  }
  
  //    func roundCorners(radius: CGFloat) {
  //        self.cornerRadius = radius
  //        if shadowOpacity != 0 {
  //            addShadowWithRoundedCorners()
  //        }
  //    }
  //
  //    private func addShadowWithRoundedCorners() {
  //        if let contents = self.contents {
  //            masksToBounds = false
  //            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
  //                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
  //            self.contents = nil
  //            if let sublayer = sublayers?.first,
  //                sublayer.name == Constants.contentLayerName {
  //                sublayer.removeFromSuperlayer()
  //            }
  //            let contentLayer = CALayer()
  //            contentLayer.name = Constants.contentLayerName
  //            contentLayer.contents = contents
  //            contentLayer.frame = bounds
  //            contentLayer.cornerRadius = cornerRadius
  //            contentLayer.masksToBounds = true
  //            insertSublayer(contentLayer, at: 0)
  //        }
  //    }
}
