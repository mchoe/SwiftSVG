//
//  SVGPath.swift
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

/////////////////////////////////////////////////////
//
// MARK: - Type Definitions

private enum PathType {
    case absolute, relative
}

private struct PreviousCommand {
    var commandLetter: String?
    var parameters: [CGFloat]?
}

/////////////////////////////////////////////////////
//
// MARK: - Protocols

private protocol Commandable {
    var numberOfRequiredParameters: Int { get }
    func execute(forPath: UIBezierPath, previousCommand: PreviousCommand?)
}

/////////////////////////////////////////////////////
//
// MARK: - Base Classes

private class PathCharacter {
    var character: Character?
    
    convenience init(character: Character) {
        self.init()
        self.character = character
    }
}

private class NumberCharacter : PathCharacter {}
private class SeparatorCharacter : PathCharacter {}
private class SignCharacter : NumberCharacter {}

private class PathCommand : PathCharacter, Commandable {
    
    var numberOfRequiredParameters: Int {
        get {
            return 0
        }
    }
    var pathType: PathType = .absolute
    var parameters: [CGFloat] = Array()
    var path: UIBezierPath = UIBezierPath()
    
    
    override init() {
        super.init()
    }
    
    convenience init(character: Character, pathType: PathType) {
        self.init()
        self.character = character
        self.pathType = pathType
    }
    
    func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        assert(false, "Subclasses must implement this method")
    }
    
    func canExecute() -> Bool {
        
        if self.numberOfRequiredParameters == 0 {
            return true
        }
        
        if self.parameters.count == 0 {
            return false
        }
        
        if self.parameters.count % self.numberOfRequiredParameters != 0 {
            return false
        }
        
        return true
    }
    
    func pushCoordinateAndExecuteIfPossible(_ coordinate: CGFloat, previousCommand: PreviousCommand? = nil) -> PreviousCommand? {
        self.parameters.append(coordinate)
        if self.canExecute() {
            self.execute(forPath: self.path, previousCommand: previousCommand)
            let returnParameters = self.parameters
            self.parameters.removeAll(keepingCapacity: false)
            return PreviousCommand(commandLetter: String(self.character!), parameters: returnParameters)
        }
        return nil
    }
    
    func pointForPathType(_ point: CGPoint) -> CGPoint {
        switch self.pathType {
        case .absolute:
            return point
        case .relative:
            return CGPoint(x: point.x + self.path.currentPoint.x, y: point.y + self.path.currentPoint.y)
        }
    }
}

/////////////////////////////////////////////////////
//
// MARK: - Command Implementations

private class MoveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 2
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = self.pointForPathType(CGPoint(x: self.parameters[0], y: self.parameters[1]))
        forPath.move(to: point)
    }
}

private class ClosePath : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 0
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        forPath.close()
    }
}

private class LineTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 2
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = self.pointForPathType(CGPoint(x: self.parameters[0], y: self.parameters[1]))
        forPath.addLine(to: point)
    }
}

private class HorizontalLineTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 1
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let x = self.parameters[0]
        let point = (self.pathType == PathType.absolute ? CGPoint(x: x, y: forPath.currentPoint.y) : CGPoint(x: forPath.currentPoint.x + x, y: forPath.currentPoint.y))
        forPath.addLine(to: point)
    }
}

private class VerticalLineTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 1
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let y = self.parameters[0]
        let point = (self.pathType == PathType.absolute ? CGPoint(x: forPath.currentPoint.x, y: y) : CGPoint(x: forPath.currentPoint.x, y: forPath.currentPoint.y + y))
        forPath.addLine(to: point)
    }
}

private class CurveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 6
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let startControl = self.pointForPathType(CGPoint(x: self.parameters[0], y: self.parameters[1]))
        let endControl = self.pointForPathType(CGPoint(x: self.parameters[2], y: self.parameters[3]))
        let point = self.pointForPathType(CGPoint(x: self.parameters[4], y: self.parameters[5]))
        forPath.addCurve(to: point, controlPoint1: startControl, controlPoint2: endControl)
    }
}

private class SmoothCurveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 4
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        if let previousParams = previousCommand?.parameters {
            
            let point = self.pointForPathType(CGPoint(x: self.parameters[2], y: self.parameters[3]))
            let controlEnd = self.pointForPathType(CGPoint(x: self.parameters[0], y: self.parameters[1]))
            
            let currentPoint = forPath.currentPoint
            
            var controlStartX = currentPoint.x
            var controlStartY = currentPoint.y
            
            if let previousChar = previousCommand?.commandLetter {
                
                switch previousChar {
                case "C":
                    controlStartX = (2.0 * currentPoint.x) - previousParams[2]
                    controlStartY = (2.0 * currentPoint.y) - previousParams[3]
                case "c":
                    let oldCurrentPoint = CGPoint(x: currentPoint.x - previousParams[4], y: currentPoint.y - previousParams[5])
                    controlStartX = (2.0 * currentPoint.x) - (previousParams[2] + oldCurrentPoint.x)
                    controlStartY = (2.0 * currentPoint.y) - (previousParams[3] + oldCurrentPoint.y)
                case "S":
                    controlStartX = (2.0 * currentPoint.x) - previousParams[0]
                    controlStartY = (2.0 * currentPoint.y) - previousParams[1]
                case "s":
                    let oldCurrentPoint = CGPoint(x: currentPoint.x - previousParams[2], y: currentPoint.y - previousParams[3])
                    controlStartX = (2.0 * currentPoint.x) - (previousParams[0] + oldCurrentPoint.x)
                    controlStartY = (2.0 * currentPoint.y) - (previousParams[1] + oldCurrentPoint.y)
                default:
                    break
                }
                
            } else {
                assert(false, "Must supply previous command for SmoothCurveTo")
            }
            
            forPath.addCurve(to: point, controlPoint1: CGPoint(x: controlStartX, y: controlStartY), controlPoint2: controlEnd)
            
        } else {
            assert(false, "Must supply previous parameters for SmoothCurveTo")
        }
    }
}

private class QuadraticCurveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 4
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let controlPoint = self.pointForPathType(CGPoint(x: self.parameters[0], y: self.parameters[1]))
        let point = self.pointForPathType(CGPoint(x: self.parameters[2], y: self.parameters[3]))
        forPath.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}

private class SmoothQuadraticCurveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 2
        }
    }
    
    override func execute(forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        if let previousParams = previousCommand?.parameters {
            
            let point = self.pointForPathType(CGPoint(x: self.parameters[0], y: self.parameters[1]))
            var controlPoint = forPath.currentPoint
            
            if let previousChar = previousCommand?.commandLetter {
                
                let currentPoint = forPath.currentPoint
                
                switch previousChar {
                case "Q":
                    controlPoint = CGPoint(x: (2.0 * currentPoint.x) - previousParams[0], y: (2.0 * currentPoint.y) - previousParams[1])
                case "q":
                    let oldCurrentPoint = CGPoint(x: currentPoint.x - previousParams[2], y: currentPoint.y - previousParams[3])
                    controlPoint = CGPoint(x: (2.0 * currentPoint.x) - (previousParams[0] + oldCurrentPoint.x), y: (2.0 * currentPoint.y) - (previousParams[1] + oldCurrentPoint.y))
                default:
                    break
                }
                
            } else {
                assert(false, "Must supply previous command for SmoothQuadraticCurveTo")
            }
            
            forPath.addQuadCurve(to: point, controlPoint: controlPoint)
            
        } else {
            assert(false, "Must supply previous parameters for SmoothQuadraticCurveTo")
        }
    }
}


/////////////////////////////////////////////////////
//
// MARK: - Character Dictionary

private let characterDictionary: [Character: PathCharacter] = [
    "M": MoveTo(character: "M", pathType: PathType.absolute),
    "m": MoveTo(character: "m", pathType: PathType.relative),
    "C": CurveTo(character: "C", pathType: PathType.absolute),
    "c": CurveTo(character: "c", pathType: PathType.relative),
    "S": SmoothCurveTo(character: "S", pathType: PathType.absolute),
    "s": SmoothCurveTo(character: "s", pathType: PathType.relative),
    "L": LineTo(character: "L", pathType: PathType.absolute),
    "l": LineTo(character: "l", pathType: PathType.relative),
    "H": HorizontalLineTo(character: "H", pathType: PathType.absolute),
    "h": HorizontalLineTo(character: "h", pathType: PathType.relative),
    "V": VerticalLineTo(character: "V", pathType: PathType.absolute),
    "v": VerticalLineTo(character: "v", pathType: PathType.relative),
    "Q": QuadraticCurveTo(character: "Q", pathType: PathType.absolute),
    "q": QuadraticCurveTo(character: "q", pathType: PathType.relative),
    "T": SmoothQuadraticCurveTo(character: "T", pathType: PathType.absolute),
    "t": SmoothQuadraticCurveTo(character: "t", pathType: PathType.relative),
    "Z": ClosePath(character: "Z", pathType: PathType.absolute),
    "z": ClosePath(character: "z", pathType: PathType.relative),
    "-": SignCharacter(character: "-"),
    ".": NumberCharacter(character: "."),
    "0": NumberCharacter(character: "0"),
    "1": NumberCharacter(character: "1"),
    "2": NumberCharacter(character: "2"),
    "3": NumberCharacter(character: "3"),
    "4": NumberCharacter(character: "4"),
    "5": NumberCharacter(character: "5"),
    "6": NumberCharacter(character: "6"),
    "7": NumberCharacter(character: "7"),
    "8": NumberCharacter(character: "8"),
    "9": NumberCharacter(character: "9"),
    " ": SeparatorCharacter(character: " "),
    ",": SeparatorCharacter(character: ",")
]

struct SVGPath: SVGShapeElement {
    
    var supportedAttributes = [String : (String) -> ()]()
    var svgLayer = CAShapeLayer()
    
    internal func parseD(pathString: String) {
        
        assert(pathString.hasPrefix("M") || pathString.hasPrefix("m"), "Path d attribute must begin with MoveTo Command (\"M\")")
        
        let workingString = (pathString.hasSuffix("Z") == false && pathString.hasSuffix("z") == false ? pathString + "z" : pathString)
        
        let returnPath = UIBezierPath()
        
        autoreleasepool { () -> () in
            
            var currentPathCommand: PathCommand = PathCommand(character: "M")
            var currentNumberStack = Stack<Character>()
            var previousParameters: PreviousCommand? = nil
            
            let pushCoordinateAndClear: () -> Void = {
                if !currentNumberStack.isEmpty {
                    if let newCoordinate = CGFloat(currentNumberStack) {
                        if let returnParameters = currentPathCommand.pushCoordinateAndExecuteIfPossible(newCoordinate, previousCommand: previousParameters) {
                            previousParameters = returnParameters
                        }
                    }
                    currentNumberStack.clear()
                }
            }
            
            for thisCharacter in workingString.characters {
                if let pathCharacter = characterDictionary[thisCharacter] {
                    
                    if pathCharacter is PathCommand {
                        
                        pushCoordinateAndClear()
                        
                        currentPathCommand = pathCharacter as! PathCommand
                        currentPathCommand.path = returnPath
                        
                        if currentPathCommand.character == "Z" || currentPathCommand.character == "z" {
                            currentPathCommand.execute(forPath: returnPath, previousCommand: previousParameters)
                        }
                        
                    } else if pathCharacter is SeparatorCharacter {
                        
                        pushCoordinateAndClear()
                        
                    } else if pathCharacter is SignCharacter {
                        
                        pushCoordinateAndClear()
                        currentNumberStack = Stack(startCharacter: thisCharacter)
                        
                    } else {
                        
                        if currentNumberStack.isEmpty == false {
                            currentNumberStack.push(thisCharacter)
                        } else {
                            currentNumberStack = Stack(startCharacter: thisCharacter)
                        }
                        
                    }
                    
                } else {
                    assert(false, "Invalid character \"\(thisCharacter)\" found")
                }
            }
        }
        self.svgLayer.path = returnPath.cgPath
    }
    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        container.containerLayer.addSublayer(self.svgLayer)
    }
    
    
}
