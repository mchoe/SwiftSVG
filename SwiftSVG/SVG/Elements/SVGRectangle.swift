//
//  SVGRectangle.swift
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

class SVGRectangle: SVGShapeElement {
    
    static var elementName: String {
        return "rect"
    }
    
    var rectangleRect = CGRect()
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : ((String) -> ())?] = [:]
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
    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        
        // TODO: There seems to be a bug with UIBezierPath(roundedRect:byRoundingCorners:cornerRadii:)
        // where it will draw an unclosed path if the corner radius is zero, so to get around this
        // you have to check which initializer to use.
        //
        // Also at some point, will have to convert this to use 2 layers because this implementation
        // only rounds the outer border and leaves the inner corners pointed.
        //
        // -Michael Choe 06.28.17
        
        let rectanglePath: UIBezierPath
        if (self.xCornerRadius > 0 || self.yCornerRadius > 0) {
            #if os(iOS) || os(tvOS)
            rectanglePath = UIBezierPath(roundedRect: self.rectangleRect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: self.xCornerRadius, height: self.yCornerRadius))
            #elseif os(OSX)
            // TODO:
            // Should create an extension that duplicates the UIBezierPath initializer
            rectanglePath = NSBezierPath(roundedRect: self.rectangleRect, xRadius: self.xCornerRadius, yRadius: self.yCornerRadius)
            #endif
            
        } else {
            rectanglePath = UIBezierPath(rect: self.rectangleRect)
        }
        self.svgLayer.path = rectanglePath.cgPath
        container.containerLayer.addSublayer(self.svgLayer)
    }
}
