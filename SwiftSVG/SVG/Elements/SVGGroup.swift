//
//  SVGGroup.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

struct SVGGroup: SVGContainerElement {
    
    var attributesToApply = [String : String]()
    var containerLayer = CALayer()
    var supportedAttributes = [String : ((String) -> ())?]()
    
    func didProcessElement(in container: SVGContainerElement?) {
        
        guard let containerSublayers = self.containerLayer.sublayers else {
            return
        }
        
        print("Should apply attributes: \(self.attributesToApply)")
        
        
        for thisSublayer in containerSublayers {
            guard let thisShapeLayer = thisSublayer as? CAShapeLayer else {
                continue
            }
            
        }
    }
    
}

extension SVGGroup: Fillable { }
extension SVGGroup: Strokable { }
