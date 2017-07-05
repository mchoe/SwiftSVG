//
//  SVGCircle.swift
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


class SVGCircle: SVGShapeElement {
    
    static var elementName: String {
        return "circle"
    }
    
    var circleCenter = CGPoint.zero
    var circleRadius: CGFloat = 0
    var svgLayer = CAShapeLayer()
    var supportedAttributes: [String : ((String) -> ())?] = [:]
    
    internal func radius(r: String) {
        guard let r = Double(lengthString: r) else {
            return
        }
        self.circleRadius = CGFloat(r)
    }
    
    internal func xCenter(x: String) {
        guard let x = Double(lengthString: x) else {
            return
        }
        self.circleCenter.x = CGFloat(x)
    }
    
    internal func yCenter(y: String) {
        guard let y = Double(lengthString: y) else {
            return
        }
        self.circleCenter.y = CGFloat(y)
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        let circlePath = UIBezierPath(arcCenter: self.circleCenter, radius: self.circleRadius, startAngle: 0, endAngle:CGFloat.pi * 2, clockwise: true)
        self.svgLayer.path = circlePath.cgPath
        container.containerLayer.addSublayer(self.svgLayer)
    }
}
