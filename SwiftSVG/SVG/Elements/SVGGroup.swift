//
//  SVGGroup.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

let groupAttributes: [String : (SVGGroup) -> (String, CAShapeLayer) -> ()] = [
    "fill": SVGGroup.fillGroup,
    "fill-rule": SVGGroup.fillRuleGroup,
    "opacity": SVGGroup.opacityGroup
]

class SVGGroup: SVGContainerElement {
    
    var attributesToApply = [String : String]()
    var containerLayer = CALayer()
    var supportedAttributes = [String : ((String) -> ())?]()
    
    func didProcessElement(in container: SVGContainerElement?) {
        
        guard let containerSublayers = self.containerLayer.sublayers else {
            return
        }
        
        for thisSublayer in containerSublayers {
            guard let thisShapeSublayer = thisSublayer as? CAShapeLayer else {
                continue
            }
            for (attribute, value) in self.attributesToApply {
                self.applyAttribute(attribute, value: value, on: thisShapeSublayer)
            }
        }
    }
    
    func applyAttribute(_ attribute: String, value: String, on layer: CAShapeLayer) {
        if let thisMethod = groupAttributes[attribute] {
            thisMethod(self)(value, layer)
        }
    }
    
    func fillGroup(_ fillColor: String, on layer: CAShapeLayer) {
        guard let fillColor = UIColor(svgString: fillColor) else {
            return
        }
        layer.fillColor = fillColor.cgColor
    }
    
    func fillRuleGroup(_ fillRule: String, on layer: CAShapeLayer) {
        guard fillRule == "evenodd" else {
            return
        }
        layer.fillRule = kCAFillRuleEvenOdd
    }
    
    func opacityGroup(_ opacity: String, on layer: CAShapeLayer) {
        guard let opacity = CGFloat(opacity) else {
            return
        }
        layer.opacity = Float(opacity)
    }
    
    func transformGroup(_ transform: String, on layer: CAShapeLayer) {
        
    }
    
}
