//
//  MapViewController.swift
//  BarFinder
//  Displays bar results in Map view
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    var placeMarkers: [PlaceAnnotation] = []
    private lazy var mapView: MKMapView = MKMapView.init(frame: self.view.bounds)
    private let regionRadius: CLLocationDistance = 2000
    
    var placeViewModel : PlaceViewModel!
    
    // MARK: - View life cycle
    
    convenience init(placeViewModel : PlaceViewModel) {
        self.init()
        self.placeViewModel = placeViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map View"
        self.navigationItem.title = "Map View"
        setupMapView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getCurrentAddressToViewController(notification:)), name: NSNotification.Name(rawValue: "sendCurrentAddressToViewController"), object: nil)
        updateUserLocationIfAuthorized()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    private func updateUserLocationIfAuthorized() {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            placeMarkers.append(contentsOf: placeViewModel.annotationList)
            updateAnnotations()
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        }
        
    }
}

// MARK:  UI methods
extension MapViewController {
    
    @objc private func getCurrentAddressToViewController(notification: NSNotification) {
        
        if let location = notification.object as? CLLocation {
            
            self.centerMapOnLocation(location: location)
            self.getNewBarData(location : location)
        }
        
    }
    
    private func setupMapView() {
        
        mapView.delegate = self
        self.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        if #available(iOS 11.0, *) {
            mapView.register(PlaceDetailView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
    }
    private func updateAnnotations() {
        
        DispatchQueue.main.async {
            
            self.mapView.annotations.forEach {
                if !($0 is MKUserLocation) {
                    self.mapView.removeAnnotation($0)
                }
            }
            self.mapView.addAnnotations(self.placeMarkers)
            self.mapView.showAnnotations(self.placeMarkers, animated: true)
        }
    }
    
    private func centerMapOnLocation(location: CLLocation) {
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
        
        placeViewModel.fetchBars(nearCoordinate: location.coordinate, completionBlock: successHandler, errorBlock: failureHandler)
        
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if #available(iOS 11.0, *) {
            let placeDetailView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            return placeDetailView
        } 
        return nil
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! PlaceAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

extension MapViewController {
    
    // When data is fetched successfully
    private func successHandler (placeModel : PlaceModel) -> Void {
        placeMarkers.removeAll()
        placeMarkers.append(contentsOf: placeViewModel.annotationList)
        updateAnnotations()
        
    }
    
    // When there is an error in fetching places. Http response code unauthorized, Connectivity issue
    private func failureHandler(error : Error?) -> Void {
        
        var message = "Unknown error in retrieving data"
      
        if let error = error  {
            if (error as NSError).code == Credential.authErrorCode {
                message = "Could not retrieve data from Google Places API. Invalid credentials"
            }
        }
        
        if Reachability.isConnectedToNetwork() == false {
            message = "No internet connection found. Please try again later."
        }
        
        showAlert(title: "Bar Finder", message: message)
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


