//
//  Transform.swift
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


enum Transform {
    case translate(CATransform3D)
}

extension Transform: RawRepresentable {
    
    typealias RawValue = String
    
    init?(rawValue: Transform.RawValue) {
        switch rawValue {
        case "translate":
            self = Transform.translate(CATransform3DIdentity)
        default:
            return nil
        }
    }
    
    init?(rawValue: Transform.RawValue, coordinatesString: String, matrix: CATransform3D = CATransform3DIdentity) {
        
        let coordinates = coordinatesString.components(separatedBy: ",").flatMap { (thisCoordinate) -> CGFloat? in
            return CGFloat(thisCoordinate.trimWhitespace())
        }
        
        switch rawValue {
        case "translate":
            guard coordinates.count > 0 else {
                return nil
            }
            if coordinates.count == 1 {
                self = Transform.translate(CATransform3DTranslate(matrix, coordinates[0], 0.0, 0.0))
                
                return
            }
            self = Transform.translate(CATransform3DTranslate(matrix, coordinates[0], coordinates[1], 0.0))
        default:
            return nil
        }
    }
    
    var rawValue: Transform.RawValue {
        switch self {
        case .translate:
            return "translate"
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

extension Transformable {
    
    var transformAttributes: [String : (String) -> ()] {
        return [
            "transform": self.transform,
        ]
    }
    
    func transform(_ transformString: String) {
        print("Should parse string and set new matrix: \(transformString)")
        do {
            let regex = try NSRegularExpression(pattern: TransformableConstants.attributesRegex, options: .caseInsensitive)
            let matches = regex.matches(in: transformString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, transformString.utf8.count))
            
            let transforms = matches.flatMap({ (thisMatch) -> Transform? in
                let nameRange = thisMatch.rangeAt(1)
                let coordinateRange = thisMatch.rangeAt(2)
                let transformName = transformString[nameRange.location..<nameRange.location + nameRange.length]
                let coordinateString = transformString[coordinateRange.location..<coordinateRange.location + coordinateRange.length]
                return Transform(rawValue: transformName, coordinatesString: coordinateString)
            })
            
            for thisTransform in transforms {
                switch thisTransform {
                case .translate(let catransform):
                    self.layerToTransform.transform = catransform
                default:
                    break
                }
            }
            
        } catch {
            print("Couldn't parse")
        }
    }
    
    func translate(to point: CGPoint) {
    
    }
}
