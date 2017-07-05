//
//  SVGEllipse.swift
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

class SVGEllipse: SVGShapeElement {
    
    static var elementName: String {
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
