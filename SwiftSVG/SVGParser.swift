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


open class SVGParser: NSObject, XMLParserDelegate {
    
    fileprivate var containerStack = Stack<SVGContainerElement>()
    
    private let configuration: SVGParserConfiguration
    open var containerLayer: CALayer?
    open fileprivate(set) var paths = [UIBezierPath]()
    
    init(parser: XMLParser, configuration: SVGParserConfiguration = SVGParserConfiguration.allFeaturesConfiguration, containerLayer: CALayer? = nil) {
        self.configuration = configuration
        super.init()
        
        if let layer = containerLayer {
            self.containerLayer = layer
        }
        
        parser.delegate = self
        parser.parse()
    }
    
    convenience init(data: Data, containerLayer: CALayer? = nil) {
        self.init(parser: XMLParser(data: data), containerLayer: containerLayer)
    }
    
    convenience init(SVGURL: URL, containerLayer: CALayer? = nil) {
        if let xmlParser = XMLParser(contentsOf: SVGURL) {
            self.init(parser: xmlParser, containerLayer: containerLayer)
        } else {
            fatalError("Couldn't initialize parser. Check your resource and make sure the supplied URL is correct")
        }
    }
    
    open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        guard let elementType = self.configuration.tags[elementName] else {
            return
        }
        
        let newInstance = elementType()
        
        for (attributeName, attributeClosure) in newInstance.supportedAttributes {
            if let attributeValue = attributeDict[attributeName] {
                attributeClosure(attributeValue)
            }
        }
        
        if let containerInstance = newInstance as? SVGContainerElement {
            self.containerStack.push(containerInstance)
        }
        
        newInstance.didProcessElement(in: self.containerStack.last)
        
        
        
        /*
        let className = NSClassFromString(newElement) as! NSObject.Type
        let newInstance = className.init()
        
        let allPropertyNames = newInstance.propertyNames()
        for thisKeyName in allPropertyNames {
            if let attributeValue: AnyObject = attributeDict[thisKeyName] as AnyObject? {
                newInstance.setValue(attributeValue, forKey: thisKeyName)
            }
        }
        
        if newInstance is SVGPathOLD {
            let thisPath = newInstance as! SVGPathOLD
            if self.containerLayer != nil {
                self.containerLayer!.addSublayer(thisPath.shapeLayer)
            }
            self.paths.append(thisPath.path)
        }
        
        self.elementStack.push(newInstance)
        */
    }
    
    
    open func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        guard let lastItem = self.containerStack.last else {
            return
        }
        
        print("Last Item: \(lastItem)")
        
        if elementName == String(describing: type(of: lastItem)) {
            _ = self.containerStack.pop()
        }
        
        /*
        if let lastItem = self.elementStack.last {
            if let keyForValue = allKeysForValue(tagMapping,valueToMatch: lastItem.classNameAsString())?.first {
                if elementName == keyForValue {
                    _ = self.elementStack.pop()
                }
            }
        }
        */
    }
    
    
}

