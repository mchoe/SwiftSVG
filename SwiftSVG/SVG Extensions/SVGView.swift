//
//  SVGView.swift
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



// TODO: Removing IBDesignable support for now seeing there
// is a bug with using IBDesignables from a framework
//
// References:
// https://openradar.appspot.com/23114017
// https://github.com/Carthage/Carthage/issues/335
// https://stackoverflow.com/questions/29933691/ibdesignable-from-external-framework

//@IBDesignable

/**
 A `UIView` subclass that can be used in Interface Builder where you can set the @IBInspectable propert `SVGName` in the side panel. Use the UIView extensions if you want to creates SVG views programmatically.
 */
open class SVGView : UIView {
    
    /**
     The name of the SVG file in the main bundle
     */
    @IBInspectable
    open var SVGName: String? {
        didSet {
            guard let thisName = self.SVGName else {
                return
            }
            
            #if TARGET_INTERFACE_BUILDER
                let bundle = Bundle(for: type(of: self))
            #else
                let bundle = Bundle.main
            #endif
            
            if let url = bundle.url(forResource: thisName, withExtension: "svg") {
                CALayer(SVGURL: url) { [weak self] (svgLayer) in
                    self?.nonOptionalLayer.addSublayer(svgLayer)
                }
            } else if #available(iOS 9.0, tvOS 9.0, OSX 10.11, *) {
                #if os(iOS) || os(tvOS)
                guard let asset = NSDataAsset(name: thisName, bundle: bundle) else {
                    return
                }
                #elseif os(OSX)
                guard let asset = NSDataAsset(name: NSDataAsset.Name(thisName as NSString), bundle: bundle) else {
                    return
                }
                #endif
                let data = asset.data
                CALayer(SVGData: data) { [weak self] (svgLayer) in
                    self?.nonOptionalLayer.addSublayer(svgLayer)
                }
            }
      
        
        }
    }
}

