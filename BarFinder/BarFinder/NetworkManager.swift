//
//  NetworkManager.swift
//  BarFinder
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

protocol NetworkService {
    func fetchPlaces(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlacesCompletion, errorBlock : @escaping PlacesError) -> Void
}

let googleApiKey = "AIzaSyDHpt5hkqDl-8KmT4lI7_T0UjSi5e6qtGE"

typealias PlacesCompletion = (Data) -> Void
typealias PlacesError = (Error?) -> Void

class NetworkManager : NetworkService {
    
    private var baseURLString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    private var placesTask: URLSessionDataTask?
    private var session: URLSession {
        return URLSession.shared
    }
    
    func fetchPlaces(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlacesCompletion, errorBlock : @escaping PlacesError) -> Void {
        
        var urlString = baseURLString + "?location=\(nearCoordinate.latitude),\(nearCoordinate.longitude)&rankby=distance&sensor=true&key=\(googleApiKey)"
        urlString += "&types=bar"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        guard let url = URL(string: urlString) else {
            errorBlock(nil)
            return
        }
        
        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        placesTask = session.dataTask(with: url) { data, response, error in

            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                errorBlock(error)
                return
            }
            guard let data = data else { errorBlock(nil); return }
            completionBlock(data)
        }
        placesTask?.resume()
    }
    
}
