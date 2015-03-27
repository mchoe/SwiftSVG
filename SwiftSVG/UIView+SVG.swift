//
//  UIView+SVG.swift
//  SwiftSVG
//
//  Created by collardgreens on 2/23/15.
//  Copyright (c) 2015 Strauss LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    convenience init(SVGURL: NSURL, fillColor: UIColor? = nil, strokeColor: UIColor? = nil, strokeWidth: CGFloat? = nil) {
        self.init()
        let shapeLayer = CAShapeLayer(SVGURL: SVGURL, fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth)
        self.layer.addSublayer(shapeLayer)
    }
}