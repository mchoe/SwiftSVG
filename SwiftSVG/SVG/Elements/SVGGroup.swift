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
    "opacity": SVGGroup.opacityGroup,
    "stroke": SVGGroup.strokeColorGroup,
    "stroke-linecap": SVGGroup.strokeLineCapGroup,
    "stroke-linejoin": SVGGroup.strokeLineJoinGroup,
    "stroke-miterlimit": SVGGroup.strokeMiterLimitGroup,
    "stroke-width": SVGGroup.strokeWidthGroup
]

class SVGGroup: SVGContainerElement {
    
    static var elementName: String {
        return "g"
    }
    
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
        container?.containerLayer.addSublayer(self.containerLayer)
    }
    
    func applyAttribute(_ attribute: String, value: String, on layer: CAShapeLayer) {
        if let thisMethod = groupAttributes[attribute] {
            thisMethod(self)(value, layer)
        }
    }
    
}

extension SVGGroup {
    
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
    
}

extension SVGGroup {
    
    internal func strokeLineCapGroup(lineCap: String, on layer: CAShapeLayer) {
        switch lineCap {
        case kCALineCapButt, kCALineCapRound, kCALineCapSquare:
            layer.lineCap = lineCap
        default:
            return
        }
    }
    
    internal func strokeColorGroup(strokeColor: String, on layer: CAShapeLayer) {
        guard let strokeColor = UIColor(svgString: strokeColor) else {
            return
        }
        layer.strokeColor = strokeColor.cgColor
    }
    
    internal func strokeLineJoinGroup(lineJoin: String, on layer: CAShapeLayer) {
        switch lineJoin {
        case kCALineJoinBevel, kCALineJoinMiter, kCALineJoinRound:
            layer.lineJoin = lineJoin
        default:
            return
        }
    }
    
    internal func strokeMiterLimitGroup(miterLimit: String, on layer: CAShapeLayer) {
        guard let miterLimit = CGFloat(miterLimit) else {
            return
        }
        layer.miterLimit = miterLimit
    }
    
    internal func strokeWidthGroup(strokeWidth: String, on layer: CAShapeLayer) {
        guard let strokeWidth = CGFloat(strokeWidth) else {
            return
        }
        layer.lineWidth = strokeWidth
    }
    
}
