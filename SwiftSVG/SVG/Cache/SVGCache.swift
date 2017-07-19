//
//  Cache.swift
//  SwiftSVG
//
//  Created by tarragon on 7/13/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

class SVGCache {
    
    static let shared = SVGCache()
    //let cacheQueue: DispatchQueue = DispatchQueue(label: "com.straussmade.swiftsvg.cache")
    
    private let memoryCache = NSCache<NSString, SVGLayer>()
    
    subscript(key: String) -> SVGLayer? {
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
}

