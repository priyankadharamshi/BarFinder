//
//  MockNetworkManager.swift
//  BarFinderTests
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import Foundation
import CoreLocation

@testable import BarFinder

class MockNetworkManager : NetworkService {
    
    var resultData : Data?
    func fetchPlaces(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlacesCompletion, errorBlock: @escaping PlacesError) {
        
        if let path = Bundle.main.path(forResource: "BarResult", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                resultData = data
                completionBlock(data)
                
            } catch  {
                print("Error in decoding JSON \(error)")
                errorBlock(error)
            }
        }
    }
    
}
