//
//  SVGLine.swift
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
 Concrete implementation that creates a `CAShapeLayer` from a `<line>` element and its attributes
 */

final class SVGLine: SVGShapeElement {
    
    /// :nodoc:
    internal static let elementName = "line"
    
    /**
     The line's end point. Defaults to `CGPoint.zero`
     */
    internal var end = CGPoint.zero
    
    /**
     The line's end point. Defaults to `CGPoint.zero`
     */
    internal var start = CGPoint.zero
    
    /// :nodoc:
    internal var svgLayer = CAShapeLayer()
    
    /// :nodoc:
    internal var supportedAttributes: [String : (String) -> ()] = [:]
    
    /**
     Function parses a number string and sets this line's start `x`
     */
    internal func x1(x1: String) {
        guard let x1 = CGFloat(x1) else {
            return
        }
        self.start.x = x1
    }
    
    /**
     Function parses a number string and sets this line's end `x`
     */
    internal func x2(x2: String) {
        guard let x2 = CGFloat(x2) else {
            return
        }
        self.end.x = x2
    }
    
    /**
     Function parses a number string and sets this line's start `y`
     */
    internal func y1(y1: String) {
        guard let y1 = CGFloat(y1) else {
            return
        }
        self.start.y = y1
    }
    
    /**
     Function parses a number string and sets this line's end `y`
     */
    internal func y2(y2: String) {
        guard let y2 = CGFloat(y2) else {
            return
        }
        self.end.y = y2
    }
    
    /**
     Draws a line from the `startPoint` to the `endPoint`
     */
    internal func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        let linePath = UIBezierPath()
        linePath.move(to: self.start)
        linePath.addLine(to: self.end)
        self.svgLayer.path = linePath.cgPath
        container.containerLayer.addSublayer(self.svgLayer)
    }
    
}
