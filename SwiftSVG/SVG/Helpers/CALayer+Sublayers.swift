//
//  CALayer+Sublayers.swift
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
 Helper functions that make it easier to find and work with sublayers
 */
extension CALayer {
    
    /**
     Helper function that applies the given closure on all sublayers of a given type
     */
    open func applyOnSublayers<T: CALayer>(ofType: T.Type, closure: (T) -> ()) {
        _ = self.sublayers(in: self).map(closure)
    }

    /**
     Helper function that returns an array of all sublayers of a given type
     */
    public func sublayers<T: CALayer, U>(in layer: T) -> [U] {
        
        var sublayers = [U]()
        
        guard let allSublayers = layer.sublayers else {
            return sublayers
        }
        
        for thisSublayer in allSublayers {
            sublayers += self.sublayers(in: thisSublayer)
            if let thisSublayer = thisSublayer as? U {
                sublayers.append(thisSublayer)
            }
        }
        return sublayers
    }
}
