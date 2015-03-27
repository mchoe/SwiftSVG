//
//  SVGCAShapeLayerExtensions.swift
//  SwiftSVG
//
//  Created by collardgreens on 2/19/15.
//  Copyright (c) 2015 Strauss LLC. All rights reserved.
//


import UIKit

extension CAShapeLayer {
    
    convenience init(pathString: String) {
        self.init()
        let svgPath = UIBezierPath(pathString: pathString)
        self.path = svgPath.CGPath
    }
    
    convenience init(SVGURL: NSURL) {
        self.init()
        let svgParser = SVGParser(SVGURL: SVGURL, containerLayer: self)
    }
}
