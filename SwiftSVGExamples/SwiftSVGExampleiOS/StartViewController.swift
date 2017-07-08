//
//  StartViewController.swift
//  SwiftSVGExamples
//
//  Created by tarragon on 7/7/17.
//  Copyright © 2017 Michael Choe. All rights reserved.
//

import UIKit


class StartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    struct StartItem {
        let title: String
        let description: String
        let segueIdentifier: String
        let prepareForSegue: ((IndexPath) -> ())?
        
        init(title: String, description: String, segueIdentifier: String, prepareForSegue: ((IndexPath) -> ())? = nil) {
            self.title = title
            self.description = description
            self.segueIdentifier = segueIdentifier
            self.prepareForSegue = prepareForSegue
        }
    }
    
    lazy var tableData: [StartItem] = {
        
        let returnData = [
            StartItem(title: "SVGView Example", description: "SVGViewExampleViewController - An example of using the SVGView in Interface Builder ", segueIdentifier: "startToSVGViewSegue"),
            StartItem(title: "Examples from GitHub", description: "All the examples on the SwiftSVG GitHub page showing the different interface options", segueIdentifier: "startToGithubSegue"),
            StartItem(title: "Rendering Verifications", description: "Lots of different examples, showing the support for various elements, attributes, and performance. Tap through further to see the selected item full size.", segueIdentifier: "startToVariousSegue")
            
        ]
        
        return returnData
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        let selectedItem = self.tableData[selectedIndexPath.row]
        segue.destination.title = selectedItem.title
        selectedItem.prepareForSegue?(selectedIndexPath)
    }
    
}

extension StartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "StartCell") as? StartCell
        let thisItem = self.tableData[indexPath.row]
        returnCell?.titleLabel.text = thisItem.title
        returnCell?.subtitleLabel.text = thisItem.description
        return returnCell!
    }
    
}

extension StartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisItem = self.tableData[indexPath.row]
        self.performSegue(withIdentifier: thisItem.segueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
