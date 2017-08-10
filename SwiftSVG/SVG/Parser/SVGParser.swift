//
//  SVGParser.swift
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


/*
struct SVGParseOptions: OptionSet {
    let rawValue: Int
    
    static let shouldParseAsynchronously = SVGParseOptions(rawValue: 1 << 0)
}
 */



/**
 A protocol describing an XML parser capable of parsing SVG data
 */
public protocol SVGParser {
    
    /**
     Initializer to create a new `SVGParser` instance
     - parameters:
        - SVGData: SVG file as Data
        - supportedElements: The elements and corresponding attribiutes the parser can parse
        - completion: A closure to execute after the parser has completed parsing and processing the SVG
     */
    init(SVGData: Data, supportedElements: SVGParserSupportedElements?, completion: ((SVGLayer) -> ())?)
    
    /// A closure that is executed after all elements have been processed. Should be guaranteed to be executed after all elements have been processed, even if parsing asynchronously.
    var completionBlock: ((SVGLayer) -> ())? { get }
    
    /// A struct listing all the elements and its attributes that should be parsed
    var supportedElements: SVGParserSupportedElements? { get }
    
    /// A `CALayer` that will house the finished sublayers of the SVG doc.
    var containerLayer: SVGLayer { get }
    
    /// Starts parsing the SVG. Allows you to separate initialization from parse start in case you want to set some things up first.
    func startParsing()
}




