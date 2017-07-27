//
//  SVGElement.swift
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

// NOTE: For the supported attributes, I wanted to use a little currying
// magic so that it could potentially take any method on any arbitrary 
// type. The type signature would look like this `[String : (Self) -> (String) -> ()]`
// 
// Unfortunately, I couldn't get this to work because the curried type wouldn't be known
// at runtime. Understandable, and my first inclination was to use type erasure to no avail. 
// I think if and when Swift adopts language level type erasure, then
// this will be possible. I'm flagging this here to keep that in mind because
// I think that will yield a cleaner design and implementation.
//
// For now, I'm still using currying, but you have to provide an instance to the partially
// applied function.
//
// -Michael Choe 06.03.17



/**
 A protocol describing an instance that can parse a single SVG element such as
 `<path>, <svg>, <rect>`.
 */

public protocol SVGElement {
    
    /**
     The element name as defined in the SVG specification
     - SeeAlso: Official [SVG Element Names](https://www.w3.org/TR/SVG/eltindex.html)
     */
    static var elementName: String { get }
    
    /**
     Dictionary of attributes of a given element that are supported by the `SVGParser`. Keys are the name of an element's attribute such as `d`, `fill`, and `rx`. Values are a closure that is used to process the given attribute.
     */
    var supportedAttributes: [String : (String) -> ()] { get set }
    
    
    /**
     An action to perform once the parser has dispatched all attributes to a given `SVGElement` instance
     - Note: If using the default `NSXMLSVGParser` and the element parses asynchronously, there is no guarantee that the instance will be finished processing all the attribites when this is called.
     */
    func didProcessElement(in container: SVGContainerElement?)
}


