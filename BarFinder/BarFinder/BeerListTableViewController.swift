//
//  BeerListTableViewController.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import UIKit

class BeerListTableViewController: UITableViewController {

    var placeViewModel : PlaceViewModel!
    var datasource : [Place] = []
    // MARK: - View life cycle
    
    convenience init(placeViewModel : PlaceViewModel) {
        self.init()
        self.placeViewModel = placeViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "List View"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BarCell")
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let placeList = placeViewModel.placeList {
            datasource = placeList.places
        }
        self.tableView.reloadData()
        
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
        return self.datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].placeName
        cell.detailTextLabel?.text = self.datasource[indexPath.row].placeAddress
        return cell
    }

}
