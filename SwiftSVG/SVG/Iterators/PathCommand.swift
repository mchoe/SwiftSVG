//
//  PathCommand.swift
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


internal enum PathType {
    case absolute, relative
}

/**
 A protocol that describes an instance that can process an individual SVG Element
 */
internal protocol PathCommand: PreviousCommand {
    
    /**
     An array that stores processed coordinates values
     */
    var coordinateBuffer: [Double] { get set }
    
    /**
     The minimum number of coordinates needed to process the path command
     */
    var numberOfRequiredParameters: Int { get }
    
    /**
     The path type, relative or absolute
     */
    var pathType: PathType { get }
    
    /**
     Designated initializer that creates a relative or absolute `PathCommand`
     */
    init(pathType: PathType)
    
    /**
     Once the `numberOfRequiredParameters` has been met, this method will append new path to the passed path
     - Parameter path: The path to append a new path to
     - Parameter previousCommand: An optional previous command. Used primarily with the shortcut cubic and quadratic Bezier types
     */
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand?)
}

/**
 A protocol that describes an instance that represents an SVGElement right before the current one
 */
internal protocol PreviousCommand {
    
    /**
     An array that stores processed coordinates values
     */
    var coordinateBuffer: [Double] { get }
    
    /**
     The path type, relative or absolute
     */
    var pathType: PathType { get }
}

internal extension PathCommand {
    
    /**
     Default implementation for any `PathCommand` indicating where there are enough coordinates stored to be able to process the `SVGElement`
     */
    var canPushCommand: Bool {
        if self.numberOfRequiredParameters == 0 {
            return true
        }
        if self.coordinateBuffer.count == 0 {
            return false
        }
        if self.coordinateBuffer.count % self.numberOfRequiredParameters == 0 {
            return true
        }
        return false
    }
    
    /**
     Function that clears the current number buffer
     */
    mutating func clearBuffer() {
        self.coordinateBuffer.removeAll()
    }
    
    /**
     Adds a new coordinate to the buffer
     */
    mutating func pushCoordinate(_ coordinate: Double) {
        self.coordinateBuffer.append(coordinate)
    }
    
    /**
     Based on the `PathType` of this PathCommand, this function returns the relative or absolute point
     */
    func pointForPathType(_ point: CGPoint, relativeTo: CGPoint) -> CGPoint {
        switch self.pathType {
        case .absolute:
            return point
        case .relative:
            return CGPoint(x: point.x + relativeTo.x, y: point.y + relativeTo.y)
        }
    }
    
}



/////////////////////////////////////////////////////
//
// MARK: - Implementations

/**
 The `PathCommand` that corresponds to the SVG `M` or `m` command
 */
internal struct MoveTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 2
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /**
     This will move the current point to `CGPoint(self.coordinateBuffer[0], self.coordinateBuffer[1])`.
     
     Sequential MoveTo commands should be treated as LineTos.
     
     From Docs (https://www.w3.org/TR/SVG2/paths.html#PathDataMovetoCommands):
     
     ```
     Start a new sub-path at the given (x,y) coordinates. M (uppercase) indicates that absolute coordinates will follow; m (lowercase) indicates that relative coordinates will follow. If a moveto is followed by multiple pairs of coordinates, the subsequent pairs are treated as implicit lineto commands. Hence, implicit lineto commands will be relative if the moveto is relative, and absolute if the moveto is absolute.
     ```
     */
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        if previousCommand is MoveTo {
            var implicitLineTo = LineTo(pathType: self.pathType)
            implicitLineTo.coordinateBuffer = [self.coordinateBuffer[0], self.coordinateBuffer[1]]
            implicitLineTo.execute(on: path)
            return
        }
        
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        path.move(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `Z` or `z` command
 */
internal struct ClosePath: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 0
    
    /// :nodoc:
    internal var pathType: PathType = .absolute
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /**
     Closes the current path
     */
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        path.close()
    }
    
}

/**
 The `PathCommand` that corresponds to the SVG `L` or `l` command
 */
internal struct LineTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 2
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /**
     Creates a line from the `path.currentPoint` to point `CGPoint(self.coordinateBuffer[0], coordinateBuffer[1])`
     */
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        path.addLine(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `H` or `h` command
 */
internal struct HorizontalLineTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 1
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /**
     Adds a horizontal line from the currentPoint to `CGPoint(self.coordinateBuffer[0], path.currentPoint.y)`
     */
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let x = self.coordinateBuffer[0]
        let point = (self.pathType == .absolute ? CGPoint(x: CGFloat(x), y: path.currentPoint.y) : CGPoint(x: path.currentPoint.x + CGFloat(x), y: path.currentPoint.y))
        path.addLine(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `V` or `v` command
 */
internal struct VerticalLineTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 1
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /**
     Adds a vertical line from the currentPoint to `CGPoint(path.currentPoint.y, self.coordinateBuffer[0])`
     */
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let y = self.coordinateBuffer[0]
        let point = (self.pathType == .absolute ? CGPoint(x: path.currentPoint.x, y: CGFloat(y)) : CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + CGFloat(y)))
        path.addLine(to: point)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `C` or `c` command
 */
internal struct CurveTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 6
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /**
     Adds a cubic Bezier curve to `path`. The path will end up at `CGPoint(self.coordinateBuffer[4], self.coordinateBuffer[5])`. The control point for `path.currentPoint` will be `CGPoint(self.coordinateBuffer[0], self.coordinateBuffer[1])`. Then controle point for the end point will be CGPoint(self.coordinateBuffer[2], self.coordinateBuffer[3])
     */
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let startControl = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        let endControl = self.pointForPathType(CGPoint(x: self.coordinateBuffer[2], y: self.coordinateBuffer[3]), relativeTo: path.currentPoint)
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[4], y: self.coordinateBuffer[5]), relativeTo: path.currentPoint)
        path.addCurve(to: point, controlPoint1: startControl, controlPoint2: endControl)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `S` or `s` command
 */
internal struct SmoothCurveTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 4
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /**
     Shortcut cubic Bezier curve to that add a new path ending up at `CGPoint(self.coordinateBuffer[0], self.coordinateBuffer[1])` with a single control point in the middle.
     */
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[2], y: self.coordinateBuffer[3]), relativeTo: path.currentPoint)
        let controlEnd = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        
        let controlStart: CGPoint
        if let previousCurveTo = previousCommand as? CurveTo  {
            switch previousCurveTo.pathType {
            case .absolute:
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousCurveTo.coordinateBuffer[2],
                    y: Double(2.0 * path.currentPoint.y) - previousCurveTo.coordinateBuffer[3]
                )
            case .relative:
                let oldCurrentPoint = (
                    Double(path.currentPoint.x) - previousCurveTo.coordinateBuffer[4],
                    Double(path.currentPoint.y) - previousCurveTo.coordinateBuffer[5]
                )
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - (previousCurveTo.coordinateBuffer[2] + oldCurrentPoint.0),
                    y: Double(2.0 * path.currentPoint.y) - (previousCurveTo.coordinateBuffer[3] + oldCurrentPoint.1)
                )
            }
        } else if let previousSmoothCurveTo = previousCommand as? SmoothCurveTo{
            switch previousSmoothCurveTo.pathType {
            case .absolute:
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousSmoothCurveTo.coordinateBuffer[0],
                    y: Double(2.0 * path.currentPoint.y) - previousSmoothCurveTo.coordinateBuffer[1]
                )
            case .relative:
                let oldCurrentPoint = (
                    Double(path.currentPoint.x) - previousSmoothCurveTo.coordinateBuffer[2],
                    Double(path.currentPoint.y) - previousSmoothCurveTo.coordinateBuffer[3]
                )
                controlStart = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - (previousSmoothCurveTo.coordinateBuffer[0] + oldCurrentPoint.0),
                    y: Double(2.0 * path.currentPoint.y) - (previousSmoothCurveTo.coordinateBuffer[1] + oldCurrentPoint.1)
                )
            }
        } else {
            controlStart = path.currentPoint
        }
        path.addCurve(to: point, controlPoint1: controlStart, controlPoint2: controlEnd)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `Q` or `q` command
 */
internal struct QuadraticCurveTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 4
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let controlPoint = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[2], y: self.coordinateBuffer[3]), relativeTo: path.currentPoint)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `T` or `t` command
 */
internal struct SmoothQuadraticCurveTo: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 2
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal var previousControlPoint: CGPoint? = nil
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        
        var controlPoint: CGPoint
        if let previousQuadraticCurveTo = previousCommand as? QuadraticCurveTo  {
            switch previousQuadraticCurveTo.pathType {
            case .absolute:
                controlPoint = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousQuadraticCurveTo.coordinateBuffer[0],
                    y: Double(2.0 * path.currentPoint.y) - previousQuadraticCurveTo.coordinateBuffer[1]
                )
            case .relative:
                let oldCurrentPoint = (
                    Double(path.currentPoint.x) - previousQuadraticCurveTo.coordinateBuffer[2],
                    Double(path.currentPoint.y) - previousQuadraticCurveTo.coordinateBuffer[3]
                )
                controlPoint = CGPoint(
                    x: Double(2.0 * path.currentPoint.x) - previousQuadraticCurveTo.coordinateBuffer[0] + oldCurrentPoint.0,
                    y: Double(2.0 * path.currentPoint.y) - previousQuadraticCurveTo.coordinateBuffer[1] + oldCurrentPoint.1
                )
            }
        } else {
            controlPoint = path.currentPoint
        }
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}

/**
 The `PathCommand` that corresponds to the SVG `A` or `a` command
 */
internal struct EllipticalArc: PathCommand {
    
    /// :nodoc:
    internal var coordinateBuffer = [Double]()
    
    /// :nodoc:
    internal let numberOfRequiredParameters = 7
    
    /// :nodoc:
    internal let pathType: PathType
    
    /// :nodoc:
    internal init(pathType: PathType) {
        self.pathType = pathType
    }
    
    /// :nodoc:
    internal func convertEndpointToCenterParameterization(
        x1: CGFloat,
        y1: CGFloat,
        x2: CGFloat,
        y2: CGFloat,
        fa: CGFloat,
        fs: CGFloat,
        rx: CGFloat,
        ry: CGFloat,
        psiDeg: CGFloat) -> CenterParametrizedEllipticalArc
    {
        var rx = rx
        var ry = ry
        let psi = psiDeg * (CGFloat.pi / 180.0)
        let xp = (cos(psi) * ((x1 - x2) / 2.0)) + (sin(psi) * ((y1 - y2) / 2.0))
        let yp = (-1 * sin(psi) * ((x1 - x2) / 2.0)) + (cos(psi) * ((y1 - y2) / 2.0))
        let lambda = (xp * xp) / (rx * rx) + (yp * yp) / (ry * ry)
        
        if (lambda > 1) {
            rx = rx * sqrt(lambda)
            ry = ry * sqrt(lambda)
        }
        
        var f = sqrt(
            (rx * rx * (ry * ry) - rx * rx * (yp * yp) - ry * ry * (xp * xp)) /
                (rx * rx * (yp * yp) + ry * ry * (xp * xp))
        )
        
        if (fa == fs) {
            f *= -1
        }
        
        if (f.isNaN) {
            f = 0
        }
        
        let cxp = (f * rx * yp) / ry
        let cyp = (f * -ry * xp) / rx
        
        let cx = (x1 + x2) / 2.0 + cos(psi) * cxp - sin(psi) * cyp
        let cy = (y1 + y2) / 2.0 + sin(psi) * cxp + cos(psi) * cyp
        
        let vMag:(Array<CGFloat>) -> CGFloat = { v -> CGFloat in
            return sqrt(v[0] * v[0] + v[1] * v[1])
        }
        let vRatio: (Array<CGFloat>,Array<CGFloat>) -> CGFloat = { u,v -> CGFloat in
            return (u[0] * v[0] + u[1] * v[1]) / (vMag(u) * vMag(v));
        };
        let vAngle: (Array<CGFloat>,Array<CGFloat>) -> CGFloat = { u,v -> CGFloat in
            return ((u[0] * v[1] < u[1] * v[0]) ? -1 : 1) * acos(vRatio(u, v))
        };
        let theta = vAngle([1, 0], [(xp - cxp) / rx, (yp - cyp) / ry])
        let u = [(xp - cxp) / rx, (yp - cyp) / ry]
        let v = [(-1 * xp - cxp) / rx, (-1 * yp - cyp) / ry]
        var dTheta = vAngle(u, v)
        
        if (vRatio(u, v) <= -1) {
            dTheta = CGFloat.pi
        }
        if (vRatio(u, v) >= 1) {
            dTheta = 0
        }
        if (fs == 0 && dTheta > 0) {
            dTheta = dTheta - 2 * CGFloat.pi
        }
        if (fs == 1 && dTheta < 0) {
            dTheta = dTheta + 2 * CGFloat.pi
        }
        return CenterParametrizedEllipticalArc(cx: cx,
                                               cy: cy,
                                               rx: rx,
                                               ry: ry,
                                               theta: theta,
                                               dTheta: dTheta,
                                               psi: psi,
                                               fs: fs)
    }
    
    /// :nodoc:
    internal func drawArc(parameters: CenterParametrizedEllipticalArc, to path: UIBezierPath)
    {
        let r = parameters.rx > parameters.ry ? parameters.rx : parameters.ry
        let scaleX = parameters.rx > parameters.ry ? 1 : parameters.rx / parameters.ry
        let scaleY = parameters.rx > parameters.ry ? parameters.ry / parameters.rx : 1
        path.apply(CGAffineTransform(translationX: -parameters.cx, y: -parameters.cy))
        path.apply(CGAffineTransform(rotationAngle: -parameters.psi))
        path.apply(CGAffineTransform(scaleX: 1/scaleX, y: 1/scaleY))
        let clockwise = (1 - parameters.fs) == 0
        path.addArc(withCenter: .zero,
                       radius: r,
                       startAngle: parameters.theta,
                       endAngle: parameters.theta + parameters.dTheta,
                       clockwise: clockwise)
        path.apply(CGAffineTransform(scaleX: scaleX, y: scaleY))
        path.apply(CGAffineTransform(rotationAngle: parameters.psi))
        path.apply(CGAffineTransform(translationX: parameters.cx, y: parameters.cy))
    }
    
    /// :nodoc:
    internal func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        let rx = CGFloat(self.coordinateBuffer[0])
        let ry = CGFloat(self.coordinateBuffer[1])
        let psi = CGFloat(self.coordinateBuffer[2])
        let fa = CGFloat(self.coordinateBuffer[3])
        let fs = CGFloat(self.coordinateBuffer[4])
        let x1 = CGFloat(path.currentPoint.x)
        let y1 = CGFloat(path.currentPoint.y)
        let ap = CGPoint(x: coordinateBuffer[5], y: coordinateBuffer[6])
        let rp = self.pointForPathType(ap, relativeTo: path.currentPoint)
        let a = self.convertEndpointToCenterParameterization(x1: x1,
                                                             y1: y1,
                                                             x2: rp.x,
                                                             y2: rp.y,
                                                             fa: fa,
                                                             fs: fs,
                                                             rx: rx,
                                                             ry: ry,
                                                             psiDeg: psi)
        
        drawArc(parameters: a, to: path)
    }
}
