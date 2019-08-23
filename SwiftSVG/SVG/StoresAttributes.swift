//
//  StoresAttributes.swift
//  SwiftSVG
//
//
//  Copyright (c) 2019 Michael Choe
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


/**
 A protocol for conforming types to store the string keys and values of the attributes that an elements has
 */
public protocol StoresAttributes {
    
    /**
     The attributes that an element has
     - parameter Key: The `String` of an element's attribute such as `d`, `fill`, and `rx`.
     - parameter Value: The `String` value of the attribute passed from the parser, such as `"#ff00ee"`
     */
    var availableAttributes: [String : String] { get set }
}


public extension SVGElement where Self: StoresAttributes {
    
    mutating func applyAttributes(_ attributes: [String : String]? = nil) {
        let attributesToApply = attributes ?? self.availableAttributes
        for (attributeName, attributeClosure) in self.supportedAttributes {
            if let attributeValue = attributesToApply[attributeName] {
                attributeClosure(attributeValue)
                print("Applied Attribute [\(attributeName)]: \(attributeValue)")
            }
        }
    }
}
