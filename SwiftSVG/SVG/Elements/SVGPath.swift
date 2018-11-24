//
//  SVGPath.swift
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

/**
 Concrete implementation that creates a `CAShapeLayer` from a `<path>` element and its attributes
 */
final class SVGPath: SVGShapeElement, ParsesAsynchronously, DelaysApplyingAttributes {
    
    /// :nodoc:
    internal static let elementName = "path"
    
    /**
     Attributes that are applied after the path has been processed
     */
    internal var delayedAttributes = [String : String]()
    
    /// :nodoc:
    internal var asyncParseManager: CanManageAsychronousParsing? = nil
    
    /**
     Flag that sets whether the path should be parsed asynchronously or not
     */
    internal var shouldParseAsynchronously = true
    
    /// :nodoc:
    internal var supportedAttributes = [String : (String) -> ()]()
    
    /// :nodoc:
    internal var svgLayer = CAShapeLayer()
    
    /// :nodoc:
    internal init() { }
    
    /**
     Initializer to to set the `svgLayer`'s cgPath. The path string does not have to be a single path for the whole element, but can include multiple subpaths in the `d` attribute. For instance, the following is a valid path string to pass:
     ```
     <path d="M30 20 L25 15 l10 50z M40 60 l80 10 l 35 55z">
     ```
     - parameter singlePathString: The `d` attribute value of a `<path>` element
     */
    internal init(singlePathString: String) {
        self.shouldParseAsynchronously = false
        self.parseD(singlePathString)
    }
    
    /**
     Function that takes a `d` path string attribute and sets the `svgLayer`'s `cgPath`
     */
    internal func parseD(_ pathString: String) {
        let workingString = pathString.trimWhitespace()
        assert(workingString.hasPrefix("M") || workingString.hasPrefix("m"), "Path d attribute must begin with MoveTo Command (\"M\")")
        autoreleasepool { () -> () in
            
            let pathDPath = UIBezierPath()
            pathDPath.move(to: CGPoint.zero)

            let parsePathClosure = {
                var previousCommand: PreviousCommand? = nil
                for thisPathCommand in PathDLexer(pathString: workingString) {
                    thisPathCommand.execute(on: pathDPath, previousCommand: previousCommand)
                    previousCommand = thisPathCommand
                }
            }
            
            if self.shouldParseAsynchronously {
                
                let concurrent = DispatchQueue(label: "com.straussmade.swiftsvg.path.concurrent", attributes: .concurrent)
                
                concurrent.async(execute: parsePathClosure)
                concurrent.async(flags: .barrier) { [weak self] in
                    guard var this = self else { return }
                    this.svgLayer.path = pathDPath.cgPath
                    this.applyDelayedAttributes()
                    this.asyncParseManager?.finishedProcessing(this.svgLayer)
                }
                
            } else {
                parsePathClosure()
                self.svgLayer.path = pathDPath.cgPath
            }
        }
    }
    
    /**
     The clip rule for this path to be applied after the path has been parsed
     */
    internal func clipRule(_ clipRule: String) {
        guard let thisPath = self.svgLayer.path else {
            self.delayedAttributes["clip-rule"] = clipRule
            return
        }
        guard clipRule == "evenodd" else {
            return
        }
        #if os(iOS) || os(tvOS)
        let bezierPath = UIBezierPath(cgPath: thisPath)
        bezierPath.usesEvenOddFillRule = true
        self.svgLayer.path = bezierPath.cgPath
        #endif
        
    }
    
    /// :nodoc:
    internal func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        container.containerLayer.addSublayer(self.svgLayer)
    }
}
