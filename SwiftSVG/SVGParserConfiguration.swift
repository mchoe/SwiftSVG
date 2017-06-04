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
                returnElement.supportedAttributes = [
                    "width": returnElement.parseWidth,
                    "height": returnElement.parseHeight
                ]
                return returnElement
            }
            
        ]
        return SVGParserConfiguration(tags: configuration)
    }
    
    public static var allFeaturesConfiguration: SVGParserConfiguration {
        
        let configuration: [String : () -> SVGElement] = [
            "circle": {
                let returnElement = SVGCircle()
                returnElement.supportedAttributes = [
                    "cx": returnElement.parseRadiusCenterX,
                    "cy": returnElement.parseRadiusCenterY,
                    "fill": returnElement.fillHex,
                    "r": returnElement.parseRadius,
                    "stroke": returnElement.strokeColor,
                    "stroke-width": returnElement.strokeWidth
                ]
                return returnElement
            },
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
                returnElement.supportedAttributes = [
                    "width": returnElement.parseWidth,
                    "height": returnElement.parseHeight
                ]
                return returnElement
            }
            
        ]
        return SVGParserConfiguration(tags: configuration)
    }
}

