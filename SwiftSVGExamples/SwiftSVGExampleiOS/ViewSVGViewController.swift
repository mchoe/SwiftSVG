//
//  ViewSVGViewController.swift
//  SwiftSVGExamples
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Michael Choe. All rights reserved.
//

import SwiftSVGiOS
import UIKit

class ViewSVGViewController: UIViewController {

    @IBOutlet weak var canvasView: UIView!
    
    var svgURL = URL(string: "NotReal")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let url = self.svgURL {
            let svgView = UIView(SVGURL: url)
            self.canvasView.addSubview(svgView)
        }
        
    }

}

extension ViewSVGViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasView
    }
    
}


