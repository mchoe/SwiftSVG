//
//  NSXMLSVGParser.swift
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



#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif




extension NSXMLSVGParser: SVGParser { }

/**
 Concrete implementation of `SVGParser` that uses Foundation's `XMLParser` to parse a given SVG file.
 */

open class NSXMLSVGParser: XMLParser, XMLParserDelegate {
    
    enum SVGParserError {
        case invalidSVG
        case invalidURL
    }
    
    fileprivate var asyncParseCount: Int = 0
    fileprivate var didDispatchAllElements = true
    
    fileprivate var elementStack = Stack<SVGElement>()
    
    /// :nodoc:
    public var completionBlock: ((SVGLayer) -> ())?
    
    /// :nodoc:
    public var supportedElements: SVGParserSupportedElements? = nil
    
    /// The `SVGLayer` that will contain all of the SVG's sublayers
    open var containerLayer = SVGLayer()
    
    let asyncCountQueue = DispatchQueue(label: "com.straussmade.swiftsvg.asyncCountQueue.serial", qos: .userInteractive)
    
    private init() {
        super.init(data: Data())
    }
    
    /**
     Convenience initializer that can initalize an `NSXMLSVGParser` using a local or remote `URL`
     - parameter SVGURL: The URL of the SVG.
     - parameter supportedElements: Optional `SVGParserSupportedElements` struct that restrict the elements and attributes that this parser can parse.If no value is provided, all supported attributes will be used.
     - parameter completion: Optional completion block that will be executed after all elements and attribites have been parsed.
     */
    public convenience init(SVGURL: URL, supportedElements: SVGParserSupportedElements? = nil, completion: ((SVGLayer) -> ())? = nil) {
        
        do {
            let urlData = try Data(contentsOf: SVGURL)
            self.init(SVGData: urlData, supportedElements: supportedElements, completion: completion)
        } catch {
            self.init()
            print("Couldn't get data from URL")
        }
    }
    
    /**
     Initializer that can initalize an `NSXMLSVGParser` using SVG `Data`
     - parameter SVGURL: The URL of the SVG.
     - parameter supportedElements: Optional `SVGParserSupportedElements` struct that restrict the elements and attributes that this parser can parse. If no value is provided, all supported attributes will be used.
     - parameter completion: Optional completion block that will be executed after all elements and attribites have been parsed.
     */
    public required init(SVGData: Data, supportedElements: SVGParserSupportedElements? = nil, completion: ((SVGLayer) -> ())? = nil) {
        super.init(data: SVGData)
        self.delegate = self
        
        if let supportedElements = supportedElements {
            self.supportedElements = supportedElements
        } else {
            self.supportedElements = SVGParserSupportedElements.allSupportedElements(for: self)
        }
        
        self.completionBlock = completion
    }
    
    public func startParsing() {
        self.asyncCountQueue.sync {
            self.didDispatchAllElements = false
        }
        self.parse()
    }
    
    /// The `XMLParserDelegate` method called when the parser has started parsing an SVG element. This implementation will loop through all supported attributes and dispatch the attribiute value to the given curried function.
    open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        guard let elementType = self.supportedElements?.tags[elementName] else {
            return
        }
        
        let svgElement = elementType()
        
        if svgElement is ParsesAsynchronously {
            self.asyncCountQueue.sync {
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
    
    /**
     The `XMLParserDelegate` method called when the parser has ended parsing an SVG element. This methods pops the last element parsed off the stack and checks if there is an enclosing container layer. Every valid SVG file is guaranteed to have at least one container layer (at a minimum, a `SVGRootElement` instance).
     
     If the parser has finished parsing a `SVGShapeElement`, it will resize the parser's `containerLayer` bounding box to fit all subpaths
     
     If the parser has finished parsing a `<svg>` element, that `SVGRootElement`'s container layer is added to this parser's `containerLayer`.
     */
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
    
    /**
     The `XMLParserDelegate` method called when the parser has finished parsing the SVG document. All supported elements and attributes are guaranteed to be dispatched at this point, but no guarantee that all elements have finished parsing.
     
     - seealso: `finishedProcessing(shapeLayer:)`
     */
    public func parserDidEndDocument(_ parser: XMLParser) {
        
        self.asyncCountQueue.sync {
            self.didDispatchAllElements = true
        }
        if self.asyncParseCount <= 0 {
            DispatchQueue.main.safeAsync {
                self.completionBlock?(self.containerLayer)
            }
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

extension NSXMLSVGParser {
    
    func resizeContainerBoundingBox(_ boundingBox: CGRect?) {
        guard let thisBoundingBox = boundingBox else {
            return
        }
        self.containerLayer.boundingBox = self.containerLayer.boundingBox.union(thisBoundingBox)
    }
}

/**
 `NSXMLSVGParser` conforms to the protocol `CanManageAsychronousCallbacks` that uses a simple reference count to see if there are any pending asynchronous tasks that have been dispatched and are still being processed. Once the element has finished processing, the asynchronous elements calls the delegate callback `func finishedProcessing(shapeLayer:)` and the delegate will decrement the count.
 */

extension NSXMLSVGParser: CanManageAsychronousCallbacks {
    
    func finishedProcessing(_ shapeLayer: CAShapeLayer) {
        
        self.asyncCountQueue.sync {
            self.asyncParseCount -= 1
        }
        
        self.resizeContainerBoundingBox(shapeLayer.path?.boundingBox)
        
        guard self.asyncParseCount <= 0 && self.didDispatchAllElements else {
            return
        }
        DispatchQueue.main.safeAsync {
            self.completionBlock?(self.containerLayer)
        }
    }
    
}
