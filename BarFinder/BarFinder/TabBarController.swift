//
//  TabBarController.swift
//  BarFinder
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import UIKit
import CoreLocation

class TabBarController: UITabBarController {
    
    var locationManager = CLLocationManager()
    private var lastLocation : CLLocation? = nil
    
    private func setupTabs() {
        let placeViewModel = PlaceViewModel()
        
        let nav1 = UINavigationController()
        let beerListTableViewController = BeerListTableViewController.init(placeViewModel: placeViewModel)
        nav1.viewControllers = [beerListTableViewController]
        nav1.tabBarItem = UITabBarItem(title: "List View", image: UIImage(named:"IconNav1"), tag: 0)
        
        let nav2 = UINavigationController()
        let mapViewController = MapViewController.init(placeViewModel : placeViewModel)
        
        nav2.viewControllers = [mapViewController]
        nav2.tabBarItem = UITabBarItem(title: "Map View", image: UIImage(named:"IconNav2"), tag: 1)
        self.viewControllers = [nav1, nav2]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: - CLLocationManager

extension TabBarController : CLLocationManagerDelegate {
    
    private func getLocation() {
        
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
    }
    
    private func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        case .denied:
            print("I'm sorry - I can't show location. User has not authorized it")
            statusDeniedAlert()
        case .restricted:
            showAlert(title: "Access to Location Services is Restricted", message: "Parental Controls or a system administrator may be limiting your access to location services. Ask them to.")
        }
    }
    
    private func statusDeniedAlert() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to show the location weather forecast, please open this app's settings and set location access to 'While Using'.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .`default`, handler: { action in
            if #available(iOS 10.0, *) {
                let settingsURL = URL(string: UIApplicationOpenSettingsURLString)!
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            } else {
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension TabBarController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
        
        showAlert(title: "Location Access Failure", message: "App could not access locations. Loation services may be unavailable or are turned off")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        lastLocation = location
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendCurrentAddressToViewController"), object:location)
        
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
