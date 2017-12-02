//
//  Identifiable
//  SwiftSVG
//
//
//  Thanks to Oliver Jones (@orj) for adding this.
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

import Foundation

public protocol Identifiable { }

extension Identifiable where Self : SVGShapeElement {
    
    /**
     The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
     - parameter Key: The SVG string value of the attribute
     - parameter Value: A curried function to use to implement the SVG attribute
     */
    var identityAttributes: [String : (String) -> ()] {
        return [
            "id": self.identify
        ]
    }

    /**
     Sets the identifier of the underlying `SVGLayer`.
     - SeeAlso: CALayer's [`name`](https://developer.apple.com/documentation/quartzcore/calayer/1410879-name) property
     */
    func identify(identifier: String) {
        self.svgLayer.name = identifier
    }
}

extension Identifiable where Self : SVGContainerElement {
    
    /**
     The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
     - parameter Key: The SVG string value of the attribute
     - parameter Value: A curried function to use to implement the SVG attribute
     */
    var identityAttributes: [String : (String) -> ()] {
        return [
            "id": self.identify
        ]
    }
    
    /**
     Sets the identifier of the underlying `SVGLayer`.
     - SeeAlso: CALayer's [`name`](https://developer.apple.com/documentation/quartzcore/calayer/1410879-name) property
     */
    func identify(identifier: String) {
        self.containerLayer.name = identifier
    }
}
