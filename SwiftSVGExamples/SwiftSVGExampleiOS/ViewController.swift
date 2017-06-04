//
//  ViewController.swift
//  SwiftSVGExampleiOS
//
//  Created by Michael Choe on 4/5/16.
//  Copyright © 2016 Michael Choe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var tableData = [URL]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "All Files"
        
        if let resourceURL = Bundle.main.resourceURL {
            do {
                let allResources = try FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                self.tableData = allResources.filter({ (thisURL) -> Bool in
                    if thisURL.pathExtension == "svg" {
                        return true
                    }
                    return false
                })
                print("All Resources: \(allResources)")
            } catch {
                print("Error getting resources")
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToDetailSegue" {
            let viewSVGVC = segue.destination as! ViewSVGViewController
            viewSVGVC.svgURL = self.tableData[self.selectedIndexPath.row]
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "AllFilesCell")!
        let thisURL = self.tableData[indexPath.row]
        returnCell.textLabel?.text = thisURL.lastPathComponent
        return returnCell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "listToDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

