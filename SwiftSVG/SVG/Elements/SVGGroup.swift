//
//  SVGGroup.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



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
