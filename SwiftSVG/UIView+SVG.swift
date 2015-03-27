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
    
    convenience init(pathString: String) {
        self.init()
        let shapeLayer = CAShapeLayer(pathString: pathString)
        self.layer.addSublayer(shapeLayer)
    }
    
    convenience init(SVGURL: NSURL) {
        self.init()
        let shapeLayer = CAShapeLayer(SVGURL: SVGURL)
        self.layer.addSublayer(shapeLayer)
    }
}