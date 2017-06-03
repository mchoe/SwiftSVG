//
//  SVGParserConfiguration.swift
//  SwiftSVG
//
//  Created by Michael Choe on 3/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

struct SVGParserConfiguration {
    
    let tags: [String : () -> SVGElement]
    
    init(tags: [String : () -> SVGElement]) {
        self.tags = tags
    }
    
    public static var barebonesConfiguration: SVGParserConfiguration {
        
        let configuration: [String : () -> SVGElement] = [
            "path": {
                var returnElement = SVGPath()
                returnElement.supportedAttributes = [
                    "d": returnElement.parseD,
                    "fill": returnElement.fillHex
                ]
                return returnElement
            },
            "svg": {
                var returnElement = SVGRootElement()
                return returnElement
            }
            
        ]
        return SVGParserConfiguration(tags: configuration)
    }
}

