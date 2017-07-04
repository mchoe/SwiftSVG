//
//  SVGParserConfiguration.swift
//  SwiftSVG
//
//  Created by Michael Choe on 3/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

public struct SVGParserConfiguration {
    
    typealias ElementGenerator = () -> SVGElement
    
    let tags: [String : ElementGenerator]
    
    public static var barebones: SVGParserConfiguration {
        
        let configuration: [String : ElementGenerator] = [
            SVGPath.elementName: {
                var returnElement = SVGPath()
                returnElement.supportedAttributes = [
                    "d": returnElement.parseD,
                    "fill": returnElement.fill
                ]
                return returnElement
            },
            SVGRootElement.elementName: {
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
    
    static func allFeaturesConfiguration(for parser: CanManageAsychronousCallbacks) -> SVGParserConfiguration {
        let configuration: [String : ElementGenerator] = [
            SVGCircle.elementName: {
                let returnElement = SVGCircle()
                returnElement.supportedAttributes = [
                    "cx": returnElement.xCenter,
                    "cy": returnElement.yCenter,
                    "r": returnElement.radius,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGEllipse.elementName: {
                let returnElement = SVGEllipse()
                returnElement.supportedAttributes = [
                    "cx": returnElement.xCenter,
                    "cy": returnElement.yCenter,
                    "rx": returnElement.xRadius,
                    "ry": returnElement.yRadius,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGGroup.elementName: {
                let returnElement = SVGGroup()
                
                // Ideally, the attributes would just use the same methods as the other fill
                // attributes of the other elements, just adding the attributes that need to
                // be applied after all the sublayers have been processed. Unfortunately, you
                // cannot do a partial application of mutating methods.
                //
                // https://stackoverflow.com/questions/37488316/partial-application-of-mutating-method-is-not-allowed
                
                
                returnElement.supportedAttributes = [
                    "fill": returnElement.fill,
                    "fill-rule": returnElement.fillRule,
                    "opacity": returnElement.opacity,
                ]
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGLine.elementName: {
                let returnElement = SVGLine()
                returnElement.supportedAttributes = [
                    "x1": returnElement.x1,
                    "x2": returnElement.x2,
                    "y1": returnElement.y1,
                    "y2": returnElement.y2,
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGPath.elementName: {
                var returnElement = SVGPath()
                returnElement.asyncParseManager = parser
                returnElement.supportedAttributes = [
                    "d": returnElement.parseD,
                    "clip-rule": returnElement.clipRule
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGPolygon.elementName: {
                var returnElement = SVGPolygon()
                returnElement.supportedAttributes = [
                    "points": returnElement.points
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGPolyline.elementName: {
                var returnElement = SVGPolyline()
                returnElement.supportedAttributes = [
                    "points": returnElement.points
                ]
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGRectangle.elementName: {
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
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGRootElement.elementName: {
                var returnElement = SVGRootElement()
                returnElement.supportedAttributes = [
                    "width": returnElement.parseWidth,
                    "height": returnElement.parseHeight,
                    "viewBox": returnElement.viewBox
                ]
                return returnElement
            }
            
        ]
        return SVGParserConfiguration(tags: configuration)
    }
    
}

