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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewSVGViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasView
    }
    
}


