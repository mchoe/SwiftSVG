//
//  SVGParserConfiguration.swift
//  SwiftSVG
//
//  Created by Michael Choe on 3/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

struct SVGParserConfiguration {
    
    typealias ElementGenerator = () -> SVGElement
    
    let tags: [String : ElementGenerator]
    
    public static var barebonesx: SVGParserConfiguration {
        
        let configuration: [String : ElementGenerator] = [
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
    
    public static var allFeatures: SVGParserConfiguration = {
        
        let configuration: [String : ElementGenerator] = [
            "circle": {
                let returnElement = SVGCircle()
                returnElement.supportedAttributes = [
                    "cx": returnElement.xCenter,
                    "cy": returnElement.yCenter,
                    "r": returnElement.radius,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                return returnElement
            },
            "ellipse": {
                let returnElement = SVGEllipse()
                returnElement.supportedAttributes = [
                    "cx": returnElement.xCenter,
                    "cy": returnElement.yCenter,
                    "rx": returnElement.xRadius,
                    "ry": returnElement.yRadius,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                return returnElement
            },
            "g": {
                var returnElement = SVGGroup()
                returnElement.supportedAttributes = [
                    "fill": nil
                ]
                return returnElement
            },
            "line": {
                let returnElement = SVGLine()
                returnElement.supportedAttributes = [
                    "x1": returnElement.x1,
                    "x2": returnElement.x2,
                    "y1": returnElement.y1,
                    "y2": returnElement.y2,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                return returnElement
            },
            "path": {
                var returnElement = SVGPath()
                returnElement.supportedAttributes = [
                    "d": returnElement.parseD,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                return returnElement
            },
            "polygon": {
                var returnElement = SVGPolygon()
                returnElement.supportedAttributes = [
                    "points": returnElement.points
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                return returnElement
            },
            "polyline": {
                var returnElement = SVGPolyline()
                returnElement.supportedAttributes = [
                    "points": returnElement.points
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                return returnElement
            },
            "rect": {
                let returnElement = SVGRectangle()
                returnElement.supportedAttributes = [
                    "height": returnElement.rectangleHeight,
                    "rx": returnElement.xCornerRadius,
                    "ry": returnElement.yCornerRadius,
                    "width": returnElement.rectangleWidth,
                    "x": returnElement.parseX,
                    "y": returnElement.parseY,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                return returnElement
            },
            "svg": {
                var returnElement = SVGRootElement()
                returnElement.supportedAttributes = [
                    "width": returnElement.parseWidth,
                    "height": returnElement.parseHeight,
                ]
                return returnElement
            }
            
        ]
        return SVGParserConfiguration(tags: configuration)
    }()
    
}

