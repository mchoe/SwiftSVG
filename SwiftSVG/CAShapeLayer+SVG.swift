//
//  SVGCAShapeLayerExtensions.swift
//  SwiftSVG
//
//  Created by collardgreens on 2/19/15.
//  Copyright (c) 2015 Strauss LLC. All rights reserved.
//


import UIKit

extension CAShapeLayer {
    
    convenience init(pathString: String, fillColor: UIColor? = nil, strokeColor: UIColor? = nil, strokeWidth: CGFloat? = nil) {
        self.init()
        let svgPath = UIBezierPath(SVGPathString: pathString)
        self.path = svgPath.CGPath
        
        if let fill = fillColor {
            self.fillColor = fill.CGColor
        }
        
        if let stroke = strokeColor {
            self.strokeColor = stroke.CGColor
        }
        
        if let lineWidth = strokeWidth {
            self.lineWidth = lineWidth
        }
    }
    
    convenience init(SVGURL: NSURL, fillColor: UIColor? = nil, strokeColor: UIColor? = nil, strokeWidth: CGFloat? = nil) {
        self.init()
        let svgParser = SVGParser(SVGURL: SVGURL, containerLayer: self)
    }
}
