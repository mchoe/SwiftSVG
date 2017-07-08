//
//  VariousCell.swift
//  SwiftSVGExamples
//
//  Created by tarragon on 7/8/17.
//  Copyright © 2017 Michael Choe. All rights reserved.
//

import UIKit

class VariousCell: UICollectionViewCell {
    
    
    @IBOutlet weak var svgView: UIView!
    
    override func prepareForReuse() {
        for thisSublayer in self.svgView.layer.sublayers! {
            thisSublayer.removeFromSuperlayer()
        }
    }
    
}
