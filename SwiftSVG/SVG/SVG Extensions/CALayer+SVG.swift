//
//  CALayer+SVG.swift
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



#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


extension CALayer {
    
    @discardableResult
    public convenience init(SVGURL: URL, parser: SVGParser? = nil, completion: ((SVGLayer) -> ())? = nil) {
        self.init()
        
        let dispatchQueue = DispatchQueue(label: "com.straussmade.swiftsvg", attributes: .concurrent)
        
        dispatchQueue.async {
            
            let parserToUse: SVGParser
            if let parser = parser {
                parserToUse = parser
            } else {
                parserToUse = NSXMLSVGParser(SVGURL: SVGURL) { (svgLayer) in
                    DispatchQueue.main.safeAsync {
                        self.addSublayer(svgLayer)
                    }
                    completion?(svgLayer)
                }
            }
            parserToUse.startParsing()
        }
    }
    
    @discardableResult
    public convenience init(SVGData: Data, parser: SVGParser? = nil, completion: ((SVGLayer) -> ())? = nil) {
        self.init()
        
        let dispatchQueue = DispatchQueue(label: "com.straussmade.swiftsvg", attributes: .concurrent)
        
        dispatchQueue.async {
            
            let parserToUse: SVGParser
            if let parser = parser {
                parserToUse = parser
            } else {
                parserToUse = NSXMLSVGParser(SVGData: SVGData) { (svgLayer) in
                    DispatchQueue.main.safeAsync {
                        self.addSublayer(svgLayer)
                    }
                    completion?(svgLayer)
                }
            }
            parserToUse.startParsing()
        }
    }
    
}

