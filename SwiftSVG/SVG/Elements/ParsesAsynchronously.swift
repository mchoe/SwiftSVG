//
//  ParsesAsynchronously.swift
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
 A protocol describing an instance that can manage elements that can parse asynchronously. In the `NSXMLSVGParser` implementation, the parser maintains a simple count of pending asynchronous tasks and decrements the count when an element has finished parsing. When the count has reached zero, a completion block is called
 */
protocol CanManageAsychronousParsing {
    /**
     The callback called when an `ParsesAsynchronously` element has finished parsing
     - Parameter shapeLayer: The completed layer
     */
    func finishedProcessing(_ shapeLayer: CAShapeLayer)
}

/**
 A protocol describing an instance that parses asynchronously
 */
protocol ParsesAsynchronously {
    /**
     The delegate instance that can manage asynchronous parsing
     */
    var asyncParseManager: CanManageAsychronousParsing? { get set }
}
