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



struct SVGPath: SVGShapeElement, ParsesAsynchronously {
    
    static var elementName: String {
        return "path"
    }
    
    var asyncParseManager: CanManageAsychronousCallbacks? = nil
    var shouldParseAsynchronously = true
    var supportedAttributes = [String : ((String) -> ())?]()
    var svgLayer = CAShapeLayer()
    
    init() { }
    
    init(singlePathString: String) {
        self.shouldParseAsynchronously = false
        self.parseD(singlePathString)
    }
    
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
                
                let concurrent = DispatchQueue(label: "concurrent", attributes: .concurrent)
                let dispatchGroup = DispatchGroup()
                
                concurrent.async(group: dispatchGroup, execute: parsePathClosure)
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    self.svgLayer.path = pathDPath.cgPath
                    self.asyncParseManager?.finishedProcessing(self.svgLayer)
                }
                
            } else {
                parsePathClosure()
                self.svgLayer.path = pathDPath.cgPath
            }
        }
    }
    
    func clipRule(_ clipRule: String) {
        if clipRule == "evenodd" {
            guard let thisPath = self.svgLayer.path else {
                print("Need to implement path evenodd")
                return
            }
            #if os(iOS) || os(tvOS)
            let bezierPath = UIBezierPath(cgPath: thisPath)
            bezierPath.usesEvenOddFillRule = true
            self.svgLayer.path = bezierPath.cgPath
            #endif
        }
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        container.containerLayer.addSublayer(self.svgLayer)
    }
}
