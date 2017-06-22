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
    let numberOfRequiredParameters = 6
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        guard let previousCommand = previousCommand else {
            assert(false, "Must supply previous parameters for SmoothCurveTo")
            return
        }
        
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[2], y: self.coordinateBuffer[3]), relativeTo: path.currentPoint)
        let controlEnd = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        
        let currentPoint = path.currentPoint
        let currentPointX = Double(currentPoint.x)
        let currentPointY = Double(currentPoint.y)
        
        var controlStartX = currentPointX
        var controlStartY = currentPointY
        
        if let previousCurveTo = previousCommand as? CurveTo {
            switch previousCurveTo.pathType {
            case .absolute:
                controlStartX = (2.0 * currentPointX) - coordinateBuffer[2]
                controlStartY = (2.0 * currentPointY) - coordinateBuffer[3]
            case .relative:
                let oldCurrentPoint = (currentPointX - coordinateBuffer[4], currentPointY - coordinateBuffer[5])
                controlStartX = (2.0 * currentPointX) - (coordinateBuffer[2] + oldCurrentPoint.0)
                controlStartY = (2.0 * currentPointY) - (coordinateBuffer[3] + oldCurrentPoint.1)
            }
        } else if let previousSmoothCurveTo = previousCommand as? SmoothCurveTo {
            switch previousSmoothCurveTo.pathType {
            case .absolute:
                controlStartX = (2.0 * currentPointX) - coordinateBuffer[0]
                controlStartY = (2.0 * currentPointY) - coordinateBuffer[1]
            case .relative:
                let oldCurrentPoint = (currentPointX - coordinateBuffer[2], currentPointY - coordinateBuffer[3])
                controlStartX = (2.0 * currentPointX) - (coordinateBuffer[0] + oldCurrentPoint.0)
                controlStartY = (2.0 * currentPointY) - (coordinateBuffer[1] + oldCurrentPoint.1)
            }
        }
        path.addCurve(to: point, controlPoint1: CGPoint(x: controlStartX, y: controlStartY), controlPoint2: controlEnd)
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
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        guard let previousCommand = previousCommand as? QuadraticCurveTo else {
            assert(false, "Must supply previous parameters for SmoothQuadraticCurveTo")
            return
        }
        
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        var controlPoint = path.currentPoint
        
        let currentPoint = path.currentPoint
        
        switch previousCommand.pathType {
        case .absolute:
            controlPoint = CGPoint(x: (2.0 * currentPoint.x) - CGFloat(coordinateBuffer[0]), y: (2.0 * currentPoint.y) - CGFloat(coordinateBuffer[1]))
        case .relative:
            let oldCurrentPoint = CGPoint(x: currentPoint.x - CGFloat(coordinateBuffer[2]), y: currentPoint.y - CGFloat(coordinateBuffer[3]))
            controlPoint = CGPoint(x: (2.0 * currentPoint.x) - (CGFloat(coordinateBuffer[0]) + oldCurrentPoint.x), y: (2.0 * currentPoint.y) - (CGFloat(coordinateBuffer[1]) + oldCurrentPoint.y))
        }
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}
