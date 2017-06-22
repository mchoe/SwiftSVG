//
//  SVGShapeElement.swift
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

protocol SVGShapeElement: SVGElement {
    var svgLayer: CAShapeLayer { get set }
}

enum LineJoinType {
    case miter, round, bevel
}

extension SVGShapeElement {
    
    var fillAndStrokeAttributes: [String : (String) -> ()] {
        return [
            "fill": self.fillHex,
            "opacity": self.opacity,
            "stroke": self.strokeColor,
            "stroke-width": self.strokeWidth
        ]
    }
    
    internal func opacity(opacity: String) {
        guard let opacity = CGFloat(opacity) else {
            return
        }
        self.svgLayer.opacity = Float(opacity)
    }
    
    internal func fillHex(fillColor: String) {
        guard let fillColor = UIColor(svgString: fillColor) else {
            return
        }
        self.svgLayer.fillColor = fillColor.cgColor
    }
    
    internal func strokeColor(strokeColor: String) {
        guard let strokeColor = UIColor(svgString: strokeColor) else {
            return
        }
        self.svgLayer.strokeColor = strokeColor.cgColor
    }
    
    internal func strokeLineJoin(lineJoin: String) {
        assert(false, "Needs Implementation")
    }
    
    internal func strokeWidth(strokeWidth: String) {
        guard let strokeWidth = Double(lengthString: strokeWidth) else {
            return
        }
        self.svgLayer.lineWidth = CGFloat(strokeWidth)
    }
    
}

