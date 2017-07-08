//
//  CALayer+SVG.swift
//  SwiftSVG
//
//  Created by tarragon on 7/6/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


extension CALayer {
    
    public convenience init(SVGURL: URL, parser: SVGParser? = nil, completion: ((SVGLayer) -> Void)? = nil) {
        self.init()
        
        DispatchQueue.global().async {
            
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
    
    public convenience init(SVGData: Data, parser: SVGParser? = nil, completion: ((SVGLayer) -> Void)? = nil) {
        self.init()
        
        DispatchQueue.global().async {
            
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
