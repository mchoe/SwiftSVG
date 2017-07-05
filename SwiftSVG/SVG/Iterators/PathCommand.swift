//
//  PathCommand.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


enum PathType {
    case absolute, relative
}

protocol PathCommand: PreviousCommand {
    
    var coordinateBuffer: [Double] { get set }
    var numberOfRequiredParameters: Int { get }
    var pathType: PathType { get }
    
    init(pathType: PathType)
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand?)
    
}

protocol PreviousCommand {
    var coordinateBuffer: [Double] { get }
    var pathType: PathType { get }
}

extension PathCommand {
    
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
    
    mutating func clearBuffer() {
        self.coordinateBuffer.removeAll()
    }
    
    mutating func pushCoordinate(_ coordinate: Double) {
        self.coordinateBuffer.append(coordinate)
    }
    
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


struct MoveTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 2
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        // Sequential MoveTo commands should be treated as LineTos
        //
        // From Docs (https://www.w3.org/TR/SVG2/paths.html#PathDataMovetoCommands):
        // Start a new sub-path at the given (x,y) coordinates. M (uppercase) indicates that absolute coordinates will follow; m (lowercase) indicates that relative coordinates will follow. If a moveto is followed by multiple pairs of coordinates, the subsequent pairs are treated as implicit lineto commands. Hence, implicit lineto commands will be relative if the moveto is relative, and absolute if the moveto is absolute.
        
        if let previousCommand = previousCommand as? MoveTo {
            var implicitLineTo = LineTo(pathType: self.pathType)
            implicitLineTo.coordinateBuffer = [self.coordinateBuffer[0], self.coordinateBuffer[1]]
            implicitLineTo.execute(on: path)
            return
        }
        
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        path.move(to: point)
    }
}

struct ClosePath: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 0
    var pathType: PathType = .absolute
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        path.close()
    }
    
}

struct LineTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 2
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        path.addLine(to: point)
    }
}

struct HorizontalLineTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 1
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let x = self.coordinateBuffer[0]
        let point = (self.pathType == .absolute ? CGPoint(x: CGFloat(x), y: path.currentPoint.y) : CGPoint(x: path.currentPoint.x + CGFloat(x), y: path.currentPoint.y))
        path.addLine(to: point)
    }
}

struct VerticalLineTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 1
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let y = self.coordinateBuffer[0]
        let point = (self.pathType == .absolute ? CGPoint(x: path.currentPoint.x, y: CGFloat(y)) : CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + CGFloat(y)))
        path.addLine(to: point)
    }
}

struct CurveTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 6
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let startControl = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        let endControl = self.pointForPathType(CGPoint(x: self.coordinateBuffer[2], y: self.coordinateBuffer[3]), relativeTo: path.currentPoint)
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[4], y: self.coordinateBuffer[5]), relativeTo: path.currentPoint)
        path.addCurve(to: point, controlPoint1: startControl, controlPoint2: endControl)
    }
}

struct SmoothCurveTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 4
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
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

struct QuadraticCurveTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 4
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let controlPoint = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[2], y: self.coordinateBuffer[3]), relativeTo: path.currentPoint)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}

struct SmoothQuadraticCurveTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 2
    let pathType: PathType
    var previousControlPoint: CGPoint? = nil
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        
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

struct EllipticalArc: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 2
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        assert(false, "Needs Implementation")
    }
}
