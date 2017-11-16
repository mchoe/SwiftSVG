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



#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif




/**
 A set of convenience initializers that create new `CALayer` instances from SVG data.
 
 If you choose to use these initializers, it is assumed that you would like to exercise a higher level of control. As such, you must provide a completion block and then add the passed `SVGLayer` to the layer of your choosing. Use the UIView extensions if you prefer the easier to use one-liner initializers.
 */
public extension CALayer {
    
    /**
     Convenience initializer that creates a new `CALayer` from a local or remote URL. You must provide a completion block and add the passed `SVGLayer to a sublayer`.
     - Parameter SVGURL: The local or remote `URL` of the SVG resource
     - Parameter parser: The optional parser to use to parse the SVG file
     - Parameter completion: A required completion block to execute once the SVG has completed parsing. You must add the passed `SVGLayer` to a sublayer to display it.
     */
    @discardableResult
    public convenience init(SVGURL: URL, parser: SVGParser? = nil, completion: @escaping (SVGLayer) -> ()) {
        do {
            let svgData = try Data(contentsOf: SVGURL)
            self.init(SVGData: svgData, parser: parser, completion: completion)
        } catch {
            self.init()
        }
    }
    
    /**
     Convenience initializer that creates a new `CALayer` from SVG data. You must provide a completion block and add the passed `SVGLayer to a sublayer`.
     - Parameter SVGData: The SVG `Data` to be parsed
     - Parameter parser: The optional parser to use to parse the SVG file
     - Parameter completion: A required completion block to execute once the SVG has completed parsing. You must add the passed `SVGLayer` to a sublayer to display it.
     */
    @discardableResult
    public convenience init(SVGData: Data, parser: SVGParser? = nil, completion: @escaping (SVGLayer) -> ()) {
        self.init()
        
        if let cached = SVGCache.default[SVGData.cacheKey] {
            DispatchQueue.main.safeAsync {
                self.addSublayer(cached)
            }
            completion(cached)
            return
        }
        
        let dispatchQueue = DispatchQueue(label: "com.straussmade.swiftsvg", attributes: .concurrent)
        
        dispatchQueue.async {
            
            let parserToUse: SVGParser
            if let parser = parser {
                parserToUse = parser
            } else {
                parserToUse = NSXMLSVGParser(SVGData: SVGData) { (svgLayer) in
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        guard let layerCopy = svgLayer.svgLayerCopy else {
                            return
                        }
                        SVGCache.default[SVGData.cacheKey] = layerCopy
                    }
                    
                    DispatchQueue.main.safeAsync {
                        self.addSublayer(svgLayer)
                    }
                    completion(svgLayer)
                }
            }
            parserToUse.startParsing()
        }
    }
    
}

