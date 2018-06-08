//
//  BeerListTableViewController.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import UIKit

class BeerListTableViewController: UITableViewController {

    var tableData = ["Bar 1", "Bar 2", "Bar 3", "Bar 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "List View"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BarCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BeerListTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarCell", for: indexPath)
        cell.textLabel?.text = "This is \(self.tableData[indexPath.row])"
        return cell
    }

}
