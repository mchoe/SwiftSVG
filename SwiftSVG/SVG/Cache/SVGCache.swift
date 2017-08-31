//
//  SVGCache.swift
//  SwiftSVG
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
 A minimal in-memory cache class for caching `SVGLayer`s. The `default` singleton is the default cache used and you can optionally create your own static singleton through an extension.
 */
open class SVGCache {
    
    /// A singleton object that is the default store for `SVGlayer`s
    public static let `default` = SVGCache()
    
    /// :nodoc:
    public let memoryCache = NSCache<NSString, SVGLayer>()
    
    /// Subscript to get or set the `SVGLayer` in this cache
    public subscript(key: String) -> SVGLayer? {
        get {
            return self.memoryCache.object(forKey: key as NSString)
        }
        set {
            guard let newValue = newValue else {
                return
            }
            self.memoryCache.setObject(newValue, forKey: key as NSString)
        }
    }
    
    /// Removes the value from the cache
    public func removeObject(key: String) {
        self.memoryCache.removeObject(forKey: key as NSString)
    }
}



