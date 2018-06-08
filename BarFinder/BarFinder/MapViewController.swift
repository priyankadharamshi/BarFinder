//
//  MapViewController.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    var placemarkers: [PlaceAnnotation] = []
    private lazy var mapView: MKMapView = MKMapView.init(frame: self.view.bounds)
    private let regionRadius: CLLocationDistance = 1000
    private let locationManager = CLLocationManager()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "BarFinder: Map View"
        self.navigationItem.title = "Map View"
        setupMapView()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getLocation()
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
}

// MARK: - CLLocationManager

extension MapViewController {
    
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
            mapView.showsUserLocation = true
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
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Location Access Failure", message: "App could not access locations. Loation services may be unavailable or are turned off")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        centerMapOnLocation(location: location)
        locationManager.stopUpdatingLocation()
        
        getNewBarData(location : location)
        
        
    }
}

// MARK:  UI methods
extension MapViewController {
    
    private func setupMapView() {
        
        mapView.delegate = self
        self.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        mapView.register(PlaceDetailView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    private func updateAnnotations() {
        
        DispatchQueue.main.async {

            self.mapView.addAnnotations(self.placemarkers)
            self.mapView.showAnnotations(self.placemarkers, animated: true)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func getNewBarData(location : CLLocation) {
        

    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! PlaceAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

extension NSLayoutConstraint {
    
    public class func useAndActivateConstraints(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}

