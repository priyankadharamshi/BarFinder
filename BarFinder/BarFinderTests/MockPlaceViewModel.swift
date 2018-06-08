//
//  MockPlaceViewModel.swift
//  BarFinderTests
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import Foundation
import CoreLocation
@testable import BarFinder

class MockPlaceViewModel : PlaceViewModel {
    
    override func fetchBars(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlaceViewModelCompletion, errorBlock: @escaping PlaceViewModelError) {
        
        if let path = Bundle.main.path(forResource: "BarResult", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let list = try decoder.decode(PlaceModel.self, from: data)
                self.placeList = list
                completionBlock(list)
                
            } catch  {
                print("Error in decoding JSON \(error)")
                errorBlock(error)
            }
        }
        
    }
    
}
