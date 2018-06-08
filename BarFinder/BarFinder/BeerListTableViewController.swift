//
//  BeerListTableViewController.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import UIKit
import CoreLocation

class BeerListTableViewController: UITableViewController {

    var placeViewModel : PlaceViewModel!
    var datasource : [Place] = []
    var currentLocation : CLLocation? = nil
    
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
        
        updateTableData()
        NotificationCenter.default.addObserver(self, selector: #selector(getCurrentAddressToViewController(notification:)), name: NSNotification.Name(rawValue: "sendCurrentAddressToViewController"), object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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

// MARK: Callbacks
extension BeerListTableViewController {
    
    // When data is fetched successfully
    private func successHandler (placeModel : PlaceModel) -> Void {
        datasource.removeAll()
        updateTableData()
        
    }
    
    // When there is an error in fetching places. Http response code unauthorized, Connectivity issue
    private func failureHandler(error : Error?) -> Void {
        
        print(error ?? "Unknown error in retrieving data")
        showAlert(title: "Bar Finder", message: "Unknown error in retrieving data")
    }
}

//MARK : UI methods
extension BeerListTableViewController {
    
    @objc func getCurrentAddressToViewController(notification: NSNotification) {
        
        currentLocation = notification.object as? CLLocation
        self.getBarData()
    
    }
    
    func getBarData() {
        if let currentLocation = currentLocation {
            placeViewModel.fetchBars(nearCoordinate: currentLocation.coordinate, completionBlock: successHandler, errorBlock: failureHandler)
        }else {
            showAlert(title: "Bar Finder", message: "No location information found.")
        }
    }
    
    private func updateTableData() {
        
        DispatchQueue.main.async {
            if let placeList = self.placeViewModel.placeList {
                self.datasource = placeList.places
            }
            self.tableView.reloadData()
        }
    }
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
