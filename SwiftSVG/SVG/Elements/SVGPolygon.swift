//
//  SVGPolygon.swift
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
 Concrete implementation that creates a `CAShapeLayer` from a `<polygon>` element and its attributes
 */

struct SVGPolygon: SVGShapeElement {
    
    static var elementName: String {
        return "polygon"
    }
    
    var supportedAttributes: [String : ((String) -> ())?] = [:]
    var svgLayer = CAShapeLayer()
    
    internal func points(points: String) {
        let polylinePath = UIBezierPath()
        for (index, thisPoint) in CoordinateLexer(coordinateString: points).enumerated() {
            if index == 0 {
                polylinePath.move(to: thisPoint)
            } else {
                polylinePath.addLine(to: thisPoint)
            }
        }
        polylinePath.close()
        self.svgLayer.path = polylinePath.cgPath
    }
    
    @discardableResult
    func didProcessElement(in container: SVGContainerElement?) -> CGPath? {
        guard let container = container else {
            return nil
        }
        container.containerLayer.addSublayer(self.svgLayer)
        return self.svgLayer.path
    }
}
