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
    
    enum SVGParserError {
        case invalidSVG
    }
    
    fileprivate var elementStack = Stack<SVGElement>()
    
    private let configuration: SVGParserConfiguration
    open var containerLayer: SVGLayer?
    open fileprivate(set) var paths = [UIBezierPath]()
    
    //var boundingBox: CGRect = CGRect.zero
    
    
    init(parser: XMLParser, configuration: SVGParserConfiguration = SVGParserConfiguration.allFeatures, containerLayer: SVGLayer? = nil) {
        self.configuration = configuration
        super.init()
        
        if let layer = containerLayer {
            self.containerLayer = layer
        }
        
        parser.delegate = self
        parser.parse()
    }
    
    convenience init(data: Data, containerLayer: SVGLayer? = nil) {
        self.init(parser: XMLParser(data: data), containerLayer: containerLayer)
    }
    
    convenience init(SVGURL: URL, containerLayer: SVGLayer? = nil) {
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
        let svgElement = elementType()
        
        for (attributeName, attributeClosure) in svgElement.supportedAttributes {
            if let attributeValue = attributeDict[attributeName] {
                attributeClosure?(attributeValue)
            }
        }
        self.elementStack.push(svgElement)
    }
    
    open func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        guard let last = self.elementStack.last else {
            return
        }
        
        guard elementName == type(of: last).elementName else {
            return
        }
        
        guard let lastElement = self.elementStack.pop() else {
            return
        }
        
        if let rootItem = lastElement as? SVGRootElement {
            DispatchQueue.main.async {
                self.containerLayer?.addSublayer(rootItem.containerLayer)
            }
            return
        }
        
        guard let containerElement = self.elementStack.last as? SVGContainerElement else {
            return
        }
        DispatchQueue.main.safeAsync {
            lastElement.didProcessElement(in: containerElement)
            
            if let lastShapeElement = lastElement as? SVGShapeElement {
                
                guard let containerLayer = self.containerLayer else {
                    return
                }
                
                guard let thisBoundingBox = lastShapeElement.boundingBox else {
                    return
                }
                containerLayer.boundingBox = containerLayer.boundingBox.union(thisBoundingBox)
                //print("Layer Bounding Box: \(thisBoundingBox)")
            }
        }
        
        
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async {
            
            //self.containerLayer?.sizeToFit()
            
            //print("Should size: \(self.boundingBox)")
            
            
            /*
            let boundingBoxLayer = CAShapeLayer()
            boundingBoxLayer.path = UIBezierPath(rect: self.boundingBox).cgPath
            boundingBoxLayer.fillColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.35).cgColor
            
            //self.containerLayer?.addSublayer(boundingBoxLayer)
            
            print("Bounding Box: \(self.boundingBox)")
            
            let containingSize = UIScreen.main.applicationFrame.size
            let boundingBoxAspectRatio = self.boundingBox.width / self.boundingBox.height
            let viewAspectRatio = containingSize.width / containingSize.height
            
            let scaleFactor: CGFloat
            if (boundingBoxAspectRatio > viewAspectRatio) {
                // Width is limiting factor
                scaleFactor = containingSize.width / self.boundingBox.width
            } else {
                // Height is limiting factor
                scaleFactor = containingSize.height / self.boundingBox.height
            }
            
            let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let translate = CGAffineTransform(translationX: -self.boundingBox.origin.x, y: -self.boundingBox.origin.y)
            let concat = translate.concatenating(scaleTransform)
            
            self.containerLayer?.setAffineTransform(scaleTransform)
            */
            
            /*
            let boundingBoxLayer = CAShapeLayer()
            boundingBoxLayer.path = UIBezierPath(rect: self.boundingBox).cgPath
            boundingBoxLayer.fillColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
            
            self.containerLayer?.addSublayer(boundingBoxLayer)
            
            print("Bounding Box: \(self.boundingBox)")
            */
            
            /*
            guard let sublayers = self.containerLayer?.sublayers else {
                return
            }
            
            var boundingBox: CGRect?
            for thisSublayer in sublayers {
                guard boundingBox != nil else {
                    boundingBox = thisSublayer.frame
                    continue
                }
                boundingBox = boundingBox?.union(thisSublayer.frame)
            }
            
            guard let thisBoundingBox = boundingBox else {
                return
            }
            
            let boundingBoxLayer = CAShapeLayer()
            boundingBoxLayer.path = UIBezierPath(rect: thisBoundingBox).cgPath
            boundingBoxLayer.fillColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
            
            self.containerLayer?.addSublayer(boundingBoxLayer)
            
            print("Bounding Box: \(boundingBoxLayer.path)")
            */
        }
        
        
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parse Error: \(parseError)")
        let code = (parseError as NSError).code
        switch code {
        case 76:
            print("Invalid XML: \(SVGParserError.invalidSVG)")
        default:
            break
        }
    }
    
    
}

