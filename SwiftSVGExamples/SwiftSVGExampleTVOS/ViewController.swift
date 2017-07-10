//
//  ViewController.swift
//  SwiftSVGExampleTVOS
//
//  Created by tarragon on 7/9/17.
//  Copyright © 2017 Michael Choe. All rights reserved.
//

import SwiftSVGiOS
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var svgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let thisSVGView = UIView()
        self.svgView.addSubview(thisSVGView)
    }
}

