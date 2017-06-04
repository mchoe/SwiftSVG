//
//  SVGRectangle.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

class SVGRectangle: SVGShapeElement {
    
    var rectangleRect = CGRect()
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : (String) -> ()] = [:]
    var xCornerRadius = CGFloat(0.0)
    var yCornerRadius = CGFloat(0.0)
    
    func parseX(x: String) {
        guard let x = Double(x) else {
            return
        }
        self.rectangleRect.origin.x = CGFloat(x)
    }
    
    func parseY(y: String) {
        guard let y = Double(y) else {
            return
        }
        self.rectangleRect.origin.y = CGFloat(y)
    }
    
    func rectangleHeight(height: String) {
        guard let height = Double(height) else {
            return
        }
        self.rectangleRect.size.height = CGFloat(height)
    }
    
    func rectangleWidth(width: String) {
        guard let width = Double(width) else {
            return
        }
        self.rectangleRect.size.width = CGFloat(width)
    }
    
    func xCornerRadius(xCornerRadius: String) {
        guard let xCornerRadius = Double(xCornerRadius) else {
            return
        }
        self.xCornerRadius = CGFloat(xCornerRadius)
    }
    
    func yCornerRadius(yCornerRadius: String) {
        guard let yCornerRadius = Double(yCornerRadius) else {
            return
        }
        self.yCornerRadius = CGFloat(yCornerRadius)
    }
    
    func didProcessElement(in parentLayer: CALayer?) {
        guard let parentLayer = parentLayer else {
            return
        }
        let rectanglePath = UIBezierPath(roundedRect: self.rectangleRect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: self.xCornerRadius, height: self.yCornerRadius))
        self.svgLayer.path = rectanglePath.cgPath
        parentLayer.addSublayer(self.svgLayer)
    }
}
