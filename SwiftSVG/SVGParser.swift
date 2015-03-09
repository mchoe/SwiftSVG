//
//  SwiftSVG.swift
//  SwiftSVG
//
//  Copyright (c) 2015 Michael Choe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//  http://www.github.com/mchoe
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


import UIKit

var tagMapping: [String: String] = [
    "path": "SVGPath",
    "svg": "SVGElement"
]

@objc(SVGGroup) class SVGGroup: NSObject { }

@objc(SVGPath) class SVGPath: NSObject {
    
    var path: UIBezierPath = UIBezierPath()
    var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    var d: String? {
        didSet{
            if let pathStringToParse = d {
                self.path = pathStringToParse.pathFromSVGString()
                self.shapeLayer.path = self.path.CGPath
            }
        }
    }
    
    var fill: String? {
        didSet {
            if let hexFill = fill {
                self.shapeLayer.fillColor = UIColor(hexString: hexFill).CGColor
            }
        }
    }
}

@objc(SVGElement) class SVGElement: NSObject { }

class SVGParser : NSObject, NSXMLParserDelegate {
    
    private var elementStack = Stack<NSObject>()
    
    var containerLayer: CALayer?
    var shouldParseSinglePathOnly: Bool = false
    var paths = [UIBezierPath]()
    
    convenience init(SVGURL: NSURL, containerLayer: CALayer? = nil, shouldParseSinglePathOnly: Bool = false) {
        
        self.init()
        
        if let layer = containerLayer {
            self.containerLayer = layer
        }
        
        if let xmlParser = NSXMLParser(contentsOfURL: SVGURL) {
            xmlParser.delegate = self
            xmlParser.parse()
        } else {
            assert(false, "Couldn't initialize parser. Check your resource and make sure the supplied URL is correct")
        }
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        if let newElement = tagMapping[elementName] {
            
            let className = NSClassFromString(newElement) as NSObject.Type
            let newInstance = className()
            
            let allPropertyNames = newInstance.propertyNames()
            for thisKeyName in allPropertyNames {
                
                if let attributeValue: AnyObject = attributeDict[thisKeyName] {
                    newInstance.setValue(attributeValue, forKey: thisKeyName)
                }
            }
            
            if newInstance is SVGPath {
                let thisPath = newInstance as SVGPath
                if self.containerLayer != nil {
                    self.containerLayer!.addSublayer(thisPath.shapeLayer)
                }
                self.paths.append(thisPath.path)
                
                if self.shouldParseSinglePathOnly == true {
                    parser.abortParsing()
                }
            }
            
            self.elementStack.push(newInstance)
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if let lastItem = self.elementStack.last {
            if let keyForValue = allKeysForValue(tagMapping, lastItem.classNameAsString())?.first {
                if elementName == keyForValue {
                    self.elementStack.pop()
                }
            }
        }
    }
    
}
