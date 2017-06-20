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
        if self.coordinateBuffer.count == 0 {
            return false
        }
        if self.coordinateBuffer.count % self.numberOfRequiredParameters == 0 {
            return true
        }
        return false
    }
    
    init(parameters: [Double], pathType: PathType, path: UIBezierPath) {
        self.init(pathType: pathType)
        self.coordinateBuffer = parameters
        self.execute(on: path, previousCommand: nil)
    }
    
    
    
    mutating func clearBuffer() {
        self.coordinateBuffer.removeAll()
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















struct MoveTo: PathCommand {
    
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 2
    let pathType: PathType
    
    init(pathType: PathType) {
        self.pathType = pathType
    }
    
    func execute(on path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = self.pointForPathType(CGPoint(x: self.coordinateBuffer[0], y: self.coordinateBuffer[1]), relativeTo: path.currentPoint)
        path.move(to: point)
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

struct ClosePath: PathCommand {
    
    var canPushCommand: Bool {
        return true
    }
    var coordinateBuffer = [Double]()
    let numberOfRequiredParameters = 1
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
        
        var controlStartX = currentPoint.x
        var controlStartY = currentPoint.y
        
        if let previousCurveTo = previousCommand as? CurveTo {
            
            if previousCurveTo.pathType == .absolute {
                controlStartX = (2.0 * currentPoint.x) - CGFloat(coordinateBuffer[2])
                controlStartY = (2.0 * currentPoint.y) - CGFloat(coordinateBuffer[3])
            } else {
                let oldCurrentPoint = CGPoint(x: currentPoint.x - CGFloat(coordinateBuffer[4]), y: currentPoint.y - CGFloat(coordinateBuffer[5]))
                controlStartX = (2.0 * currentPoint.x) - (CGFloat(coordinateBuffer[2]) + oldCurrentPoint.x)
                controlStartY = (2.0 * currentPoint.y) - (CGFloat(coordinateBuffer[3]) + oldCurrentPoint.y)
            }
            
        } else if let previousSmoothCurveTo = previousCommand as? SmoothCurveTo {
            
            if previousSmoothCurveTo.pathType == .absolute {
                controlStartX = (2.0 * currentPoint.x) - CGFloat(coordinateBuffer[0])
                controlStartY = (2.0 * currentPoint.y) - CGFloat(coordinateBuffer[1])
            } else {
                let oldCurrentPoint = CGPoint(x: currentPoint.x - CGFloat(coordinateBuffer[2]), y: currentPoint.y - CGFloat(coordinateBuffer[3]))
                controlStartX = (2.0 * currentPoint.x) - (CGFloat(coordinateBuffer[0]) + oldCurrentPoint.x)
                controlStartY = (2.0 * currentPoint.y) - (CGFloat(coordinateBuffer[1]) + oldCurrentPoint.y)
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
