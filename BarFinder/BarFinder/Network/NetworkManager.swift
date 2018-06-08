//
//  NetworkManager.swift
//  BarFinder
//  Manages calls to Google Place API
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

protocol NetworkService {
    func fetchPlaces(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlacesCompletion, errorBlock : @escaping PlacesError) -> Void
}

typealias PlacesCompletion = (Data) -> Void
typealias PlacesError = (Error?) -> Void

class NetworkManager : NetworkService {
    
   
    private var placesTask: URLSessionDataTask?
    private var session: URLSession {
        return URLSession.shared
    }
    
    func fetchPlaces(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlacesCompletion, errorBlock : @escaping PlacesError) -> Void {
        
        var urlString = RequestURLProvider().googleAPIURLString + "?location=\(nearCoordinate.latitude),\(nearCoordinate.longitude)&rankby=distance&sensor=true&key=\(Credential.googleApiKey)"
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
