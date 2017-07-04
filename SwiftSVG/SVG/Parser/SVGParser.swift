//
//  SVGParser.swift
//  SwiftSVG
//
//  Created by Michael Choe on 3/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif



public protocol SVGParsable { }

extension Data: SVGParsable { }
extension URL: SVGParsable { }


public protocol SVGParser {
    var completionBlock: ((SVGLayer) -> Void)? { get }
    var configuration: SVGParserConfiguration? { get }
    var containerLayer: SVGLayer { get }
    
    init(SVGURL: URL, configuration: SVGParserConfiguration?, completion: ((SVGLayer) -> Void)?)
    func startParsing()
}


