//
//  UIView+SVG.swift
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



import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif


/**
 A set of convenience initializers that create new `UIView` instances from SVG data
 */
public extension UIView {
    
    /**
     Convenience initializer that instantiates a new `UIView` instance with a single path `d` string. The path will be parsed synchronously.
     ```
     let view = UIView(pathString: "M20 30 L30 10 l10 10")
     ```
     - Parameter pathString: The path `d` string to parse.
     */
    public convenience init(pathString: String) {
        self.init()
        let svgLayer = SVGLayer()
        let pathPath = UIBezierPath(pathString: pathString)
        svgLayer.path = pathPath.cgPath
        #if os(iOS) || os(tvOS)
        self.layer.addSublayer(svgLayer)
        #elseif os(OSX)
        self.nonOptionalLayer.addSublayer(svgLayer)
        #endif
    }
    
    /**
     Convenience initializer that instantiates a new `UIView` for the given SVG file in the main bundle
     ```
     let view = UIView(SVGNamed: "hawaiiFlowers")
     ```
     - Parameter SVGNamed: The name of the SVG resource in the main bundle with an `.svg` extension or the name an asset in the main Asset Catalog as a Data Asset.
     - Parameter parser: The optional parser to use to parse the SVG file
     - Parameter completion: A required completion block to execute once the SVG has completed parsing. The passed `SVGLayer` will be added to this view's sublayers before executing the completion block
     */
    public convenience init(SVGNamed: String, parser: SVGParser? = nil, completion: ((SVGLayer) -> ())? = nil) {
        
        // TODO: This is too many guards to really make any sense. Also approaching on the
        // pyramid of death Refactor this at some point to be able to work cross-platform.
        if #available(iOS 9.0, OSX 10.11, *) {
            
            var data: Data?
            #if os(iOS)
            if let asset = NSDataAsset(name: SVGNamed) {
                data = asset.data
            }
            #elseif os(OSX)
            if let asset = NSDataAsset(name: NSDataAsset.Name(SVGNamed)) {
                data = asset.data
            }
            #endif
            
            guard let unwrapped = data else {
                guard let svgURL = Bundle.main.url(forResource: SVGNamed, withExtension: "svg") else {
                    self.init()
                    return
                }
                do {
                    let thisData = try Data(contentsOf: svgURL)
                    self.init(SVGData: thisData, parser: parser, completion: completion)
                } catch {
                    self.init()
                    return
                }
                return
            }
            self.init(SVGData: unwrapped, parser: parser, completion: completion)
        } else {
            guard let svgURL = Bundle.main.url(forResource: SVGNamed, withExtension: "svg") else {
                self.init()
                return
            }
            do {
                let data = try Data(contentsOf: svgURL)
                self.init(SVGData: data, parser: parser, completion: completion)
            } catch {
                self.init()
                return
            }
        }
    }
    
    /**
     Convenience initializer that instantiates a new `UIView` instance for the given SVG file at the given URL
     
     Upon completion, it will resize the layer to aspect fit this view's superview
     ```
     let view = UIView(SVGURL: "hawaiiFlowers", parser: aParser) { (svgLayer) in
        // Do something with the passed svgLayer
     }
     ```
     - Parameter SVGURL: The local or remote `URL` of the SVG resource
     - Parameter parser: The optional parser to use to parse the SVG file
     - Parameter completion: A required completion block to execute once the SVG has completed parsing. The passed `SVGLayer` will be added to this view's sublayers before executing the completion block
     */
    public convenience init(SVGURL: URL, parser: SVGParser? = nil, completion: ((SVGLayer) -> ())? = nil) {
        do {
            let svgData = try Data(contentsOf: SVGURL)
            self.init(SVGData: svgData, parser: parser, completion: completion)
        } catch {
            self.init()
            Swift.print("No data at URL: \(SVGURL)")
        }
    }
	
    /**
     Convenience initializer that instantiates a new `UIView` instance with the given SVG data
     
     Upon completion, it will resize the layer to aspect fit this view's superview
     ```
     let view = UIView(SVGData: svgData)
     ```
     - Parameter SVGData: The SVG `Data` to be parsed
     - Parameter parser: The optional parser to use to parse the SVG file
     - Parameter completion: A required completion block to execute once the SVG has completed parsing. The passed `SVGLayer` will be added to this view's sublayers before executing the completion block
     */
	public convenience init(SVGData svgData: Data, parser: SVGParser? = nil, completion: ((SVGLayer) -> ())? = nil) {
		self.init()
        
        CALayer(SVGData: svgData, parser: parser) { [weak self] (svgLayer) in
            DispatchQueue.main.safeAsync {
                self?.nonOptionalLayer.addSublayer(svgLayer)
            }
            completion?(svgLayer)
        }
	}
    
}
