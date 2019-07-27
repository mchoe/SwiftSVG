//
//  SVGParserConfiguration.swift
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

/**
 A struct that lists all the supported elements and attributes for a parser
 */
public struct SVGParserSupportedElements {
    
    /**
     Typealias that serves as a placeholder for a closure that returns a new `SVGElement` instance
     */
    public typealias ElementGenerator = () -> SVGElement
    
    /**
     A dictionary of all the supported elements and attributes for a given parser.
     - Parameter Key: A string that matches the SVG attribute
     - Parameter Value: A curried function to use to handle the particular attribute
     */
    public let tags: [String : ElementGenerator]
    
    /**
     Initializer to create your own set of supported tags
     - Parameter tags: Dictionary of SVG tag name keys and a closure values return an `SVGElement`
     */
    public init(tags: [String : ElementGenerator]) {
        self.tags = tags
    }
    
    /**
     A configuration that will only parse `<path>` elements and the `d` and `fill attributes`. Use this configuration if you know you will only be parsing `<path>` elements with fill colors
     */
    public static var barebones: SVGParserSupportedElements {
        
        let supportedElements: [String : ElementGenerator] = [
            SVGPath.elementName: {
                let returnElement = SVGPath()
                returnElement.supportedAttributes = [
                    "d": unown(returnElement, SVGPath.parseD),
                    "fill": unown(returnElement, SVGPath.fill)
                ]
                return returnElement
            },
            SVGRootElement.elementName: {
                return SVGRootElement()
            }
        ]
        return SVGParserSupportedElements(tags: supportedElements)
    }
    
    /**
     A configuration that is the full set of elements and attributes that SwiftSVG supports. This is the default configuration for the `NSXMLSVGParser`.
     */
    public static var allSupportedElements: SVGParserSupportedElements {
        let supportedElements: [String : ElementGenerator] = [
            SVGCircle.elementName: {
                let returnElement = SVGCircle()
                returnElement.supportedAttributes = [
                    "cx": unown(returnElement, SVGCircle.xCenter),
                    "cy": unown(returnElement, SVGCircle.yCenter),
                    "r": unown(returnElement, SVGCircle.radius),
                ]
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGEllipse.elementName: {
                let returnElement = SVGEllipse()
                returnElement.supportedAttributes = [
                  "cx": unown(returnElement, SVGEllipse.xCenter),
                  "cy": unown(returnElement, SVGEllipse.yCenter),
                  "rx": unown(returnElement, SVGEllipse.xRadius),
                  "ry": unown(returnElement, SVGEllipse.yRadius),
                ]
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGGroup.elementName: {
                let returnElement = SVGGroup()
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGLine.elementName: {
                let returnElement = SVGLine()
                returnElement.supportedAttributes = [
                    "x1": unown(returnElement, SVGLine.x1),
                    "x2": unown(returnElement, SVGLine.x2),
                    "y1": unown(returnElement, SVGLine.y1),
                    "y2": unown(returnElement, SVGLine.y2),
                ]
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGPath.elementName: {
                let returnElement = SVGPath()
                returnElement.supportedAttributes = [
                    "d": unown(returnElement, SVGPath.parseD),
                    "clip-rule": unown(returnElement, SVGPath.clipRule),
                ]
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGPolygon.elementName: {
                var returnElement = SVGPolygon()
                returnElement.supportedAttributes = [
                    "points":  returnElement.points,
                ]
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGPolyline.elementName: {
                var returnElement = SVGPolyline()
                returnElement.supportedAttributes = [
                    "points":  returnElement.points,
                ]
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                returnElement.supportedAttributes.add(returnElement.fillAttributes)
                returnElement.supportedAttributes.add(returnElement.strokeAttributes)
                returnElement.supportedAttributes.add(returnElement.styleAttributes)
                returnElement.supportedAttributes.add(returnElement.transformAttributes)
                return returnElement
            },
            SVGRectangle.elementName: {
                let returnElement = SVGRectangle()
                returnElement.supportedAttributes = [
                    "height": unown(returnElement, SVGRectangle.rectangleHeight),
                    "rx": unown(returnElement, SVGRectangle.xCornerRadius),
                    "ry": unown(returnElement, SVGRectangle.yCornerRadius),
                    "width": unown(returnElement, SVGRectangle.rectangleWidth),
                    "x": unown(returnElement, SVGRectangle.parseX),
                    "y": unown(returnElement, SVGRectangle.parseY),
                ]
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
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
                returnElement.supportedAttributes.add(returnElement.identityAttributes)
                return returnElement
            }
            
        ]
        return SVGParserSupportedElements(tags: supportedElements)
    }
    
}

