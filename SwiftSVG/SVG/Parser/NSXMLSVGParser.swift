//
//  NSXMLSVGParser.swift
//  SwiftSVG
//
//  Created by tarragon on 7/1/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

extension NSXMLSVGParser: SVGParser { }


open class NSXMLSVGParser: XMLParser, XMLParserDelegate {
    
    enum SVGParserError {
        case invalidSVG
    }
    
    fileprivate var asyncParseCount: Int = 0
    fileprivate var didDispatchAllElements = true
    
    fileprivate var elementStack = Stack<SVGElement>()
    
    public var completionBlock: ((SVGLayer) -> Void)?
    public var configuration: SVGParserConfiguration? = nil
    open var containerLayer = SVGLayer()
    
    //open fileprivate(set) var paths = [UIBezierPath]()
    //let xmlParser: XMLParser
    
    let concurrentQueue = DispatchQueue(label: "com.straussmade.swiftsvg", attributes: .concurrent)
    let dispatchGroup = DispatchGroup()
    
    let parseSerial = DispatchQueue(label: "com.straussmade.swiftsvg.parse.serial", qos: .userInteractive)
    
    
    
    public required init(SVGURL: URL, configuration: SVGParserConfiguration? = nil, completion: ((SVGLayer) -> Void)? = nil) {
        
        let urlData = try! Data(contentsOf: SVGURL)
        super.init(data: urlData)
        self.delegate = self
        
        if let configuration = configuration {
            self.configuration = configuration
        } else {
            self.configuration = SVGParserConfiguration.allFeaturesConfiguration(for: self)
        }
        
        self.completionBlock = completion
    }
    
    
    
    /*
    init(parser: XMLParser, configuration: SVGParserConfiguration = SVGParserConfiguration.allFeatures, containerLayer: SVGLayer, completion: ((SVGLayer) -> Void)? = nil) {
        
        self.configuration = configuration
        self.containerLayer = containerLayer
        self.completionBlock = completion
        super.init()
        
        parser.delegate = self
        parser.parse()
    }
    */
    
    /*
     convenience init(data: Data, containerLayer: SVGLayer? = nil) {
     
     self.init(parser: XMLParser(data: data), containerLayer: containerLayer)
     }
     */
    
    /*
    convenience init(SVGURL: URL, containerLayer: SVGLayer? = nil, completion: ((SVGLayer) -> Void)? = nil) {
        if let xmlParser = XMLParser(contentsOf: SVGURL) {
            let container: SVGLayer
            if let containerLayer = containerLayer {
                container = containerLayer
            } else {
                container = SVGLayer(SVGURL: SVGURL)
            }
            self.init(parser: xmlParser, containerLayer: container, completion: completion)
            
        } else {
            fatalError("Couldn't initialize parser. Check your resource and make sure the supplied URL is correct")
        }
    }
    */
    
    public func startParsing() {
        self.parseSerial.sync {
            self.didDispatchAllElements = false
        }
        self.parse()
    }
    
    
    open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        guard let elementType = self.configuration?.tags[elementName] else {
            return
        }
        
        let svgElement = elementType()
        
        if svgElement is ParsesAsynchronously {
            self.parseSerial.sync {
                self.asyncParseCount += 1
            }
        }
        
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
            DispatchQueue.main.safeAsync {
                self.containerLayer.addSublayer(rootItem.containerLayer)
            }
            return
        }
        
        guard let containerElement = self.elementStack.last as? SVGContainerElement else {
            return
        }
        
        lastElement.didProcessElement(in: containerElement)
        
        if let lastShapeElement = lastElement as? SVGShapeElement {
            self.resizeContainerBoundingBox(lastShapeElement.boundingBox)
        }
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        
        self.parseSerial.sync {
            self.didDispatchAllElements = true
        }
        
        guard self.asyncParseCount <= 0 else {
            return
        }
        
        print("Finished Dispatching: \(self.didDispatchAllElements) - \(self.asyncParseCount)")
        self.completionBlock?(self.containerLayer)
        
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

extension NSXMLSVGParser {
    
    func resizeContainerBoundingBox(_ boundingBox: CGRect?) {
        guard let thisBoundingBox = boundingBox else {
            return
        }
        self.containerLayer.boundingBox = self.containerLayer.boundingBox.union(thisBoundingBox)
    }
}

extension NSXMLSVGParser: CanManageAsychronousCallbacks {
    
    func finishedProcessing(_ boundingBox: CGRect?) {
        
        self.parseSerial.sync {
            self.asyncParseCount -= 1
        }
        
        self.resizeContainerBoundingBox(boundingBox)
        
        guard self.asyncParseCount <= 0 && self.didDispatchAllElements else {
            return
        }
        print("Finished Parsing Document [\(self.didDispatchAllElements)]: \(self.containerLayer.boundingBox)")
        self.completionBlock?(self.containerLayer)
    }
    
}
