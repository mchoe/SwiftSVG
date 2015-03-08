//
//  String+SVG.swift
//  SwiftSVG
//
//  Copyright (c) 2015 Michael Choe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//  http://www.github.com/mchoe
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

/////////////////////////////////////////////////////
//
// MARK: Type Definitions

enum PathType {
    case Absolute, Relative
}

struct NumberStack {
    var characterStack: String = ""
    var asCGFloat: CGFloat? {
        get {
            if self.characterStack.utf16Count > 0 {
                return CGFloat(strtod(self.characterStack, nil))
            }
            return nil
        }
    }
    var isEmpty: Bool {
        get {
            if self.characterStack.utf16Count > 0 {
                return false
            }
            return true
        }
    }
    
    init() { }
    
    init(startCharacter: Character) {
        self.characterStack = String(startCharacter)
    }
    
    mutating func push(character: Character) {
        self.characterStack += String(character)
    }
    
    mutating func clear() {
        self.characterStack = String()
    }
}

struct PreviousCommand {
    var commandLetter: String?
    var parameters: [CGFloat]?
}

/////////////////////////////////////////////////////
//
// MARK: Protocols

protocol Commandable {
    var numberOfRequiredParameters: Int { get }
    func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand?)
}

/////////////////////////////////////////////////////
//
// MARK: Base Classes

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
    var pathType: PathType = .Absolute
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
    
    func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
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
    
    func pushCoordinateAndExecuteIfPossible(coordinate: CGFloat, previousCommand: PreviousCommand? = nil) -> PreviousCommand? {
        self.parameters.append(coordinate)
        if self.canExecute() {
            self.execute(forPath: self.path, previousCommand: previousCommand)
            let returnParameters = self.parameters
            self.parameters.removeAll(keepCapacity: false)
            return PreviousCommand(commandLetter: String(self.character!), parameters: returnParameters)
        }
        return nil
    }
    
    func pointForPathType(point: CGPoint) -> CGPoint {
        switch self.pathType {
        case .Absolute:
            return point
        case .Relative:
            return CGPointMake(point.x + self.path.currentPoint.x, point.y + self.path.currentPoint.y)
        }
    }
}

/////////////////////////////////////////////////////
//
// MARK: Command Implementations

private class MoveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 2
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = self.pointForPathType(CGPointMake(self.parameters[0], self.parameters[1]))
        forPath.moveToPoint(point)
    }
}

private class ClosePath : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 0
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        forPath.closePath()
    }
}

private class LineTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 2
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let point = self.pointForPathType(CGPointMake(self.parameters[0], self.parameters[1]))
        forPath.addLineToPoint(point)
    }
}

private class HorizontalLineTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 1
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let x = self.parameters[0]
        let point = (self.pathType == PathType.Absolute ? CGPointMake(x, forPath.currentPoint.y) : CGPointMake(forPath.currentPoint.x + x, forPath.currentPoint.y))
        forPath.addLineToPoint(point)
    }
}

private class VerticalLineTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 1
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let y = self.parameters[0]
        let point = (self.pathType == PathType.Absolute ? CGPointMake(forPath.currentPoint.x, y) : CGPointMake(forPath.currentPoint.x, forPath.currentPoint.y + y))
        forPath.addLineToPoint(point)
    }
}

private class CurveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 6
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let startControl = self.pointForPathType(CGPointMake(self.parameters[0], self.parameters[1]))
        let endControl = self.pointForPathType(CGPointMake(self.parameters[2], self.parameters[3]))
        let point = self.pointForPathType(CGPointMake(self.parameters[4], self.parameters[5]))
        forPath.addCurveToPoint(point, controlPoint1: startControl, controlPoint2: endControl)
    }
}

private class SmoothCurveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 4
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        if let previousParams = previousCommand?.parameters {
            
            let point = self.pointForPathType(CGPointMake(self.parameters[2], self.parameters[3]))
            let controlEnd = self.pointForPathType(CGPointMake(self.parameters[0], self.parameters[1]))
            
            let currentPoint = forPath.currentPoint
            
            var controlStartX = currentPoint.x
            var controlStartY = currentPoint.y
            
            if let previousChar = previousCommand?.commandLetter {
                
                switch previousChar {
                case "C":
                    controlStartX = (2.0 * currentPoint.x) - previousParams[2]
                    controlStartY = (2.0 * currentPoint.y) - previousParams[3]
                case "c":
                    let oldCurrentPoint = CGPointMake(currentPoint.x - previousParams[4], currentPoint.y - previousParams[5])
                    controlStartX = (2.0 * currentPoint.x) - (previousParams[2] + oldCurrentPoint.x)
                    controlStartY = (2.0 * currentPoint.y) - (previousParams[3] + oldCurrentPoint.y)
                case "S":
                    controlStartX = (2.0 * currentPoint.x) - previousParams[0]
                    controlStartY = (2.0 * currentPoint.y) - previousParams[1]
                case "s":
                    let oldCurrentPoint = CGPointMake(currentPoint.x - previousParams[2], currentPoint.y - previousParams[3])
                    controlStartX = (2.0 * currentPoint.x) - (previousParams[0] + oldCurrentPoint.x)
                    controlStartY = (2.0 * currentPoint.y) - (previousParams[1] + oldCurrentPoint.y)
                default:
                    break
                }
                
            } else {
                assert(false, "Must supply previous command for SmoothCurveTo")
            }
            
            forPath.addCurveToPoint(point, controlPoint1: CGPointMake(controlStartX, controlStartY), controlPoint2: controlEnd)
            
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
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        let controlPoint = self.pointForPathType(CGPointMake(self.parameters[0], self.parameters[1]))
        let point = self.pointForPathType(CGPointMake(self.parameters[2], self.parameters[3]))
        forPath.addQuadCurveToPoint(point, controlPoint: controlPoint)
    }
}

private class SmoothQuadraticCurveTo : PathCommand {
    
    override var numberOfRequiredParameters: Int {
        get {
            return 2
        }
    }
    
    override func execute(#forPath: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        
        if let previousParams = previousCommand?.parameters {
            
            let point = self.pointForPathType(CGPointMake(self.parameters[0], self.parameters[1]))
            var controlPoint = forPath.currentPoint
            
            if let previousChar = previousCommand?.commandLetter {
                
                let currentPoint = forPath.currentPoint
                
                switch previousChar {
                case "Q":
                    controlPoint = CGPointMake((2.0 * currentPoint.x) - previousParams[0], (2.0 * currentPoint.y) - previousParams[1])
                case "q":
                    let oldCurrentPoint = CGPointMake(currentPoint.x - previousParams[2], currentPoint.y - previousParams[3])
                    controlPoint = CGPointMake((2.0 * currentPoint.x) - (previousParams[0] + oldCurrentPoint.x), (2.0 * currentPoint.y) - (previousParams[1] + oldCurrentPoint.y))
                default:
                    break
                }
                
            } else {
                assert(false, "Must supply previous command for SmoothQuadraticCurveTo")
            }
            
            forPath.addQuadCurveToPoint(point, controlPoint: controlPoint)
            
        } else {
            assert(false, "Must supply previous parameters for SmoothQuadraticCurveTo")
        }
    }
}


/////////////////////////////////////////////////////
//
// MARK: Character Dictionary

private let characterDictionary: [Character: PathCharacter] = [
    "M": MoveTo(character: "M", pathType: PathType.Absolute),
    "m": MoveTo(character: "m", pathType: PathType.Relative),
    "C": CurveTo(character: "C", pathType: PathType.Absolute),
    "c": CurveTo(character: "c", pathType: PathType.Relative),
    "S": SmoothCurveTo(character: "S", pathType: PathType.Absolute),
    "s": SmoothCurveTo(character: "s", pathType: PathType.Relative),
    "L": LineTo(character: "L", pathType: PathType.Absolute),
    "l": LineTo(character: "l", pathType: PathType.Relative),
    "H": HorizontalLineTo(character: "H", pathType: PathType.Absolute),
    "h": HorizontalLineTo(character: "h", pathType: PathType.Relative),
    "V": VerticalLineTo(character: "V", pathType: PathType.Absolute),
    "v": VerticalLineTo(character: "v", pathType: PathType.Relative),
    "Q": QuadraticCurveTo(character: "Q", pathType: PathType.Absolute),
    "q": QuadraticCurveTo(character: "q", pathType: PathType.Relative),
    "T": SmoothQuadraticCurveTo(character: "T", pathType: PathType.Absolute),
    "t": SmoothQuadraticCurveTo(character: "t", pathType: PathType.Relative),
    "Z": ClosePath(character: "Z", pathType: PathType.Absolute),
    "z": ClosePath(character: "z", pathType: PathType.Relative),
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


/////////////////////////////////////////////////////
//
// MARK: Parse "d" path


/////////////////////////////////////////////////////
//
// This String extension is provided as a convenience for the 
// parseSVGPath function. You can use either the extension or the
// global function. I just wanted to provide


extension String {
    func pathFromSVGString() -> UIBezierPath {
        return parseSVGPath(self)
    }
}

func parseSVGPath(pathString: String, forPath: UIBezierPath? = nil) -> UIBezierPath {
    
    assert(pathString.hasPrefix("M") || pathString.hasPrefix("m"), "Path d attribute must begin with MoveTo Command (\"M\")")
    
    let workingString = (pathString.hasSuffix("Z") == false && pathString.hasSuffix("z") == false ? pathString + "z" : pathString)
    
    var returnPath = UIBezierPath()
    
    if let suppliedPath = forPath {
        returnPath = suppliedPath
    }
    
    autoreleasepool { () -> () in
        
        var currentPathCommand: PathCommand = PathCommand(character: "M")
        var currentNumberStack: NumberStack = NumberStack()
        var previousParameters: PreviousCommand? = nil
        
        let pushCoordinateAndClear: () -> Void = {
            if currentNumberStack.isEmpty == false {
                if let newCoordinate = currentNumberStack.asCGFloat {
                    if let returnParameters = currentPathCommand.pushCoordinateAndExecuteIfPossible(newCoordinate, previousCommand: previousParameters) {
                        previousParameters = returnParameters
                    }
                }
                currentNumberStack.clear()
            }
        }
        
        for thisCharacter in workingString {
            if var pathCharacter = characterDictionary[thisCharacter] {
                
                if pathCharacter is PathCommand {
                    
                    pushCoordinateAndClear()
                    
                    currentPathCommand = pathCharacter as PathCommand
                    currentPathCommand.path = returnPath
                    
                    if currentPathCommand.character == "Z" || currentPathCommand.character == "z" {
                        currentPathCommand.execute(forPath: returnPath, previousCommand: previousParameters)
                    }
                    
                } else if pathCharacter is SeparatorCharacter {
                    
                    pushCoordinateAndClear()
                    
                } else if pathCharacter is SignCharacter {
                    
                    pushCoordinateAndClear()
                    currentNumberStack = NumberStack(startCharacter: thisCharacter)
                    
                } else {
                    
                    if currentNumberStack.isEmpty == false {
                        currentNumberStack.push(thisCharacter)
                    } else {
                        currentNumberStack = NumberStack(startCharacter: thisCharacter)
                    }
                    
                }
                
            } else {
                assert(false, "Invalid character \"\(thisCharacter)\" found")
            }
        }
    }
    return returnPath
}

