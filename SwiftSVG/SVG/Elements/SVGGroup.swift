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



#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

/**
 Concrete implementation that creates a container from a `<g>` element and applies its attribites to all sublayers
 */

final class SVGGroup: SVGContainerElement {
    
    /// :nodoc:
    fileprivate static let groupAttributes: [String : (SVGGroup) -> (String, CAShapeLayer) -> ()] = [
        "fill": SVGGroup.fillGroup,
        "fill-rule": SVGGroup.fillRuleGroup,
        "opacity": SVGGroup.fillOpacityGroup,
        "stroke": SVGGroup.strokeColorGroup,
        "stroke-linecap": SVGGroup.strokeLineCapGroup,
        "stroke-linejoin": SVGGroup.strokeLineJoinGroup,
        "stroke-miterlimit": SVGGroup.strokeMiterLimitGroup,
        "stroke-width": SVGGroup.strokeWidthGroup
    ]
    
    /// :nodoc:
    internal static let elementName = "g"
    
    /// Store all attributes and values to be applied after all known sublayers have been added to this container
    internal var delayedAttributes = [String : String]()
    
    /// A `CALayer` that will hold all sublayers of the `SVGGroup`
    internal var containerLayer = CALayer()
    
    /// :nodoc:
    internal var supportedAttributes = [String : (String) -> ()]()
    
    /**
     The function that is called after all of this group's subelements have been processed. It will apply all stored `delayedAttributes` on all sublayers
     */
    internal func didProcessElement(in container: SVGContainerElement?) {
 
        guard let containerSublayers = self.containerLayer.sublayers else {
            return
        }
        
        for thisSublayer in containerSublayers {
            guard let thisShapeSublayer = thisSublayer as? CAShapeLayer else {
                continue
            }
            for (attribute, value) in self.delayedAttributes {
                self.applyAttribute(attribute, value: value, on: thisShapeSublayer)
            }
        }
        container?.containerLayer.addSublayer(self.containerLayer)
    }
    
    /**
     Function that will apply the String attribute and value on the passed sublayer
     */
    fileprivate func applyAttribute(_ attribute: String, value: String, on layer: CAShapeLayer) {
        if let thisMethod = SVGGroup.groupAttributes[attribute] {
            thisMethod(self)(value, layer)
        }
    }
    
}

fileprivate extension SVGGroup {
    
    /**
     Function that applies the fill color on all of this group's subelements
     */
    func fillGroup(_ fillColor: String, on layer: CAShapeLayer) {
        guard let fillColor = UIColor(svgString: fillColor) else {
            return
        }
        layer.fillColor = fillColor.cgColor
    }
    
    /**
     Function that applies the fill rule on all of this group's subelements
     */
    func fillRuleGroup(_ fillRule: String, on layer: CAShapeLayer) {
        guard fillRule == "evenodd" else {
            return
        }
        layer.fillRule = CAShapeLayerFillRule.evenOdd
    }
    
    /**
     Function that applies the fill opacity on all of this group's subelements
     */
    func fillOpacityGroup(_ opacity: String, on layer: CAShapeLayer) {
        guard let opacity = Float(opacity) else {
            return
        }
        layer.opacity = opacity
    }
    
}

fileprivate extension SVGGroup {
    
    /**
     Function that applies the stroke line cap on all of this group's subelements
     */
    func strokeLineCapGroup(lineCap: String, on layer: CAShapeLayer) {
        layer.lineCap = CAShapeLayerLineCap(rawValue: lineCap)
    }
    
    /**
     Function that applies the stroke color on all of this group's subelements
     */
    func strokeColorGroup(strokeColor: String, on layer: CAShapeLayer) {
        guard let strokeColor = UIColor(svgString: strokeColor) else {
            return
        }
        layer.strokeColor = strokeColor.cgColor
    }
    
    /**
     Function that applies the stroke line join on all of this group's subelements
     */
    func strokeLineJoinGroup(lineJoin: String, on layer: CAShapeLayer) {
        layer.lineJoin = CAShapeLayerLineJoin(rawValue: lineJoin)
    }
    
    /**
     Function that applies the miter limit on all of this group's subelements
     */
    func strokeMiterLimitGroup(miterLimit: String, on layer: CAShapeLayer) {
        guard let miterLimit = CGFloat(miterLimit) else {
            return
        }
        layer.miterLimit = miterLimit
    }
    
    /**
     Function that applies the streoke width on all of this group's subelements
     */
    func strokeWidthGroup(strokeWidth: String, on layer: CAShapeLayer) {
        guard let strokeWidth = CGFloat(strokeWidth) else {
            return
        }
        layer.lineWidth = strokeWidth
    }
    
}
