//
//  Fillable.swift
//  SwiftSVG
//
//  Created by tarragon on 6/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif



protocol Fillable { }

extension Fillable where Self : SVGShapeElement {
    
    var fillAttributes: [String : (String) -> ()] {
        return [
            "fill": self.fill,
            "fill-rule": self.fillRule,
            "opacity": self.opacity,
        ]
    }
    
    func fill(fillColor: String) {
        guard let fillColor = UIColor(svgString: fillColor) else {
            return
        }
        self.svgLayer.fillColor = fillColor.cgColor
    }
    
    func fillRule(fillRule: String) {
        guard fillRule == "evenodd" else {
            return
        }
        self.svgLayer.fillRule = kCAFillRuleEvenOdd
    }
    
    func opacity(opacity: String) {
        guard let opacity = CGFloat(opacity) else {
            return
        }
        self.svgLayer.opacity = Float(opacity)
    }
    
}

extension Fillable where Self : SVGGroup {
    
    /*
    var fillAttributes: [String : (String) -> ()] {
        return [
            "fill": self.fill,
            "fill-rule": self.fillRule,
            "opacity": self.opacity,
        ]
    }
    */
    
    func fill(fillColor: String) {
        self.attributesToApply["fill"] = fillColor
    }
    
    func fillRule(fillRule: String) {
        self.attributesToApply["fill-rule"] = fillRule
    }
    
    func opacity(opacity: String) {
        self.attributesToApply["opacity"] = opacity
    }
    
}

