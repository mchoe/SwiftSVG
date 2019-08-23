//
//  SVGContainerElement.swift
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
 A protocol that describes an instance that can store SVG sublayers and can apply a single attributes to all sublayers.
 */

public protocol SVGContainerElement: SVGElement, DelaysApplyingAttributes, StoresAttributes, Fillable, Strokable, Transformable, Stylable, Identifiable {
    
    /**
     The layer that stores all the SVG sublayers
     */
    var containerLayer: CALayer { get set }
}

/**
 A type-erased struct, to be used with generics
 */
internal struct AnySVGContainerElement: SVGContainerElement {
    static var elementName: String {
        fatalError()
    }
    
    var supportedAttributes: [String : (String) -> ()] {
        get {
            return self.base.supportedAttributes
        }
        set {
            self.base.supportedAttributes = newValue
        }
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        self.base.didProcessElement(in: container)
    }
    
    var delayedAttributes: [String : String] {
        get {
            return self.base.delayedAttributes
        }
        set {
            self.base.delayedAttributes = newValue
        }
    }
    
    var containerLayer: CALayer {
        get {
            return self.base.containerLayer
        }
        set {
            return self.base.containerLayer = newValue
        }
    }
    
    var availableAttributes: [String : String] {
        get {
            return self.base.availableAttributes
        }
        set {
            self.base.availableAttributes = newValue
        }
    }
    
    private var base: SVGContainerElement
    
    init(_ base: SVGContainerElement) {
        self.base = base
    }
}
