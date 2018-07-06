//
//  DelaysApplyingAttributes.swift
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
 A protocol that describes an instance that will delay processing attributes, usually until in `didProcessElement(in container: SVGContainerElement?)` because either all path information isn't available or when the element needs to apply an attribute to all subelements.
 */
public protocol DelaysApplyingAttributes {
    
    /**
     The attributes to apply to all sublayers after all subelements have been processed.
     - parameter Key: The name of an element's attribute such as `d`, `fill`, and `rx`.
     - parameter Value: The string value of the attribute passed from the parser, such as `"#ff00ee"`
     */
    var delayedAttributes: [String : String] { get set }
}

/**
 An extension that applies any saved and supported attributes
 */
extension DelaysApplyingAttributes where Self : SVGElement {
    
    /**
     Applies any saved and supported attributes
     */
    public mutating func applyDelayedAttributes() {
        for (attribute, value) in self.delayedAttributes {
            guard let closure = self.supportedAttributes[attribute] else {
                continue
            }
            closure(value)
        }
      
      self.supportedAttributes.removeAll()
      self.delayedAttributes.removeAll()
    }
}
