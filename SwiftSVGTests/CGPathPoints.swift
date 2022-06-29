//
//  CGPathPoints.swift
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



import UIKit
import SwiftSVG

extension CGPath {
    
    var points: [CGPoint] {
        var arrayPoints = [CGPoint]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            case .closeSubpath:
                arrayPoints.append(element.points[0])
            @unknown default:
                fatalError("CGPath:points: no such element")
            }
        }
        return arrayPoints
    }
    
    var pointsAndTypes: [(CGPoint, CGPathElementType)] {
        var arrayPoints = [(CGPoint, CGPathElementType)]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append((element.points[0], .moveToPoint))
            case .addLineToPoint:
                arrayPoints.append((element.points[0], .addLineToPoint))
            case .addQuadCurveToPoint:
                arrayPoints.append((element.points[0], .addQuadCurveToPoint))
                arrayPoints.append((element.points[1], .addQuadCurveToPoint))
            case .addCurveToPoint:
                arrayPoints.append((element.points[0], .addCurveToPoint))
                arrayPoints.append((element.points[1], .addCurveToPoint))
                arrayPoints.append((element.points[2], .addCurveToPoint))
            case .closeSubpath:
                arrayPoints.append((element.points[0], .closeSubpath))
            @unknown default:
                fatalError("CGPath:points: no such element")
            }
        }
        return arrayPoints
    }
    
    private func forEach(body: @escaping @convention(block) (CGPathElement) -> ()) {
        typealias Body = @convention(block) (CGPathElement) -> ()
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> () = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
}

extension PathCommand {
    
    init(parameters: [Double], pathType: PathType, path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        self.init(pathType: pathType)
        self.coordinateBuffer = parameters
        self.execute(on: path, previousCommand: previousCommand)
    }
    
}
