//
//  Transformable.swift
//  SwiftSVG
//
//  Created by tarragon on 6/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif




struct Transform {
    
    let affineTransform: CGAffineTransform
    
    init?(rawValue: String, coordinatesString: String) {
        
        let coordinatesArray = coordinatesString.components(separatedBy: CharacterSet(charactersIn: ", "))
        
        guard coordinatesArray.count > 0 else {
            return nil
        }
        
        let coordinates = coordinatesArray.flatMap { (thisCoordinate) -> CGFloat? in
            return CGFloat(thisCoordinate.trimWhitespace())
        }
        
        guard coordinates.count > 0 else {
            return nil
        }
        
        switch rawValue {
        case "matrix":
            guard coordinates.count >= 6 else {
                return nil
            }
            self.affineTransform = CGAffineTransform(
                a: coordinates[0], b: coordinates[1],
                c: coordinates[2], d: coordinates[3],
                tx: coordinates[4], ty: coordinates[5]
            )
            
        case "rotate":
            if coordinates.count == 1 {
                let degrees = CGFloat(coordinates[0])
                self.affineTransform = CGAffineTransform(rotationAngle: degrees.degreesToRadians)
            } else if coordinates.count == 3 {
                let degrees = CGFloat(coordinates[0])
                let translate = CGAffineTransform(translationX: coordinates[0], y: coordinates[1])
                let rotate = CGAffineTransform(rotationAngle: degrees.degreesToRadians)
                let translateReverse = CGAffineTransform(translationX: -coordinates[0], y: -coordinates[1])
                self.affineTransform = translate.concatenating(rotate).concatenating(translateReverse)
            } else {
                return nil
            }
            
        case "scale":
            if coordinates.count == 1 {
                self.affineTransform = CGAffineTransform(scaleX: coordinates[0], y: coordinates[0])
            } else {
                self.affineTransform = CGAffineTransform(scaleX: coordinates[0], y: coordinates[1])
            }
            
        case "skewX":
            self.affineTransform = CGAffineTransform(
                a: 1.0, b: tan(coordinates[0]),
                c: 0.0, d: 1.0,
                tx: 0.0, ty: 0.0
            )
        case "skewY":
            self.affineTransform = CGAffineTransform(
                a: 1.0, b: 0.0,
                c: tan(coordinates[0]), d: 1.0,
                tx: 0.0, ty: 0.0
            )
            
        case "translate":
            if coordinates.count == 1 {
                self.affineTransform = CGAffineTransform(translationX: coordinates[0], y: 0.0)
                return
            }
            self.affineTransform = CGAffineTransform(translationX: coordinates[0], y: coordinates[1])
        
        default:
            return nil
        }
    }
}


private struct TransformableConstants {
    static let attributesRegex = "(\\w+)\\(((\\-?\\d+\\.?\\d*e?\\-?\\d*\\s*,?\\s*)+)\\)"
}

protocol Transformable {
    var layerToTransform: CALayer { get }
}

extension Transformable where Self : SVGContainerElement {
    var layerToTransform: CALayer {
        return self.containerLayer
    }
}

extension Transformable where Self: SVGShapeElement {
    var layerToTransform: CALayer {
        return self.svgLayer
    }
}

extension Transformable {
    
    var transformAttributes: [String : (String) -> ()] {
        return [
            "transform": self.transform,
        ]
    }
    
    func transform(_ transformString: String) {
        
        print("Transform: \(transformString)")
        
        do {
            let regex = try NSRegularExpression(pattern: TransformableConstants.attributesRegex, options: .caseInsensitive)
            let matches = regex.matches(in: transformString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, transformString.utf8.count))
            
            let combinedTransforms = matches
            .flatMap({ (thisMatch) -> Transform? in
                let nameRange = thisMatch.rangeAt(1)
                let coordinateRange = thisMatch.rangeAt(2)
                let transformName = transformString[nameRange.location..<nameRange.location + nameRange.length]
                let coordinateString = transformString[coordinateRange.location..<coordinateRange.location + coordinateRange.length]
                return Transform(rawValue: transformName, coordinatesString: coordinateString)
            })
            .reduce(CGAffineTransform.identity, { (accumulate, next) -> CGAffineTransform in
                print("Next: \(next)")
                return accumulate.concatenating(next.affineTransform)
            })
            print("All Transforms: \(combinedTransforms)")
            self.layerToTransform.setAffineTransform(combinedTransforms)
            
        } catch {
            print("Couldn't parse transform string: \(transformString)")
        }
    }
}
