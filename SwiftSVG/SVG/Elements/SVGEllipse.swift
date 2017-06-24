//
//  SVGEllipse.swift
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

class SVGEllipse: SVGShapeElement {
    
    var elementName: String {
        return "ellipse"
    }
    var ellipseCenter = CGPoint.zero
    var xRadius: CGFloat = 0
    var yRadius: CGFloat = 0
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : ((String) -> ())?] = [:]
    
    internal func xRadius(r: String) {
        guard let r = Double(lengthString: r) else {
            return
        }
        self.xRadius = CGFloat(r)
    }
    
    internal func yRadius(r: String) {
        guard let r = Double(lengthString: r) else {
            return
        }
        self.yRadius = CGFloat(r)
    }
    
    internal func xCenter(x: String) {
        guard let x = Double(lengthString: x) else {
            return
        }
        self.ellipseCenter.x = CGFloat(x)
    }
    
    internal func yCenter(y: String) {
        guard let y = Double(lengthString: y) else {
            return
        }
        self.ellipseCenter.y = CGFloat(y)
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        let ellipseRect = CGRect(x: self.ellipseCenter.x - self.xRadius, y: self.ellipseCenter.y - self.yRadius, width: 2 * self.xRadius, height: 2 * self.yRadius)
        let circlePath = UIBezierPath(ovalIn: ellipseRect)
        self.svgLayer.path = circlePath.cgPath
        container.containerLayer.addSublayer(self.svgLayer)
    }
    
}
