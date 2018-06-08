//
//  PlaceViewModel.swift
//  BarFinder
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

typealias PlaceViewModelCompletion = (PlaceModel) -> Void
typealias PlaceViewModelError = (Error?) -> Void

protocol DataService {
    func fetchBars(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlaceViewModelCompletion, errorBlock : @escaping PlaceViewModelError) -> Void
}
class PlaceViewModel : NSObject, DataService {
    
    var placeList: PlaceModel? = nil
    var dataCacheManager = DataCache()
    var annotationResults : [PlaceAnnotation] {
        get {
            var tempAnnotations: [PlaceAnnotation] = []
            if let placeList = placeList {
                for place in placeList.places {
                    let annotation = PlaceAnnotation.init(withPlace: place)
                    tempAnnotations.append(annotation)
                }
               
            }
            return tempAnnotations
        }
    }
    static let defaultErrorMessage = "Error in retrieving data from server."
    
    private var networkManager = NetworkManager()
    private var successBlock : PlaceViewModelCompletion? = nil
    private var failureBlock : PlaceViewModelError? = nil
    
    override init() {
        self.placeList = dataCacheManager.getPlaceInfoFromDisk()
        super.init()
        
    }
    
    func fetchBars(nearCoordinate: CLLocationCoordinate2D, completionBlock: @escaping PlaceViewModelCompletion, errorBlock: @escaping PlaceViewModelError) {
        self.successBlock = completionBlock
        self.failureBlock = errorBlock
        networkManager.fetchPlaces(nearCoordinate: nearCoordinate, completionBlock: successHandler, errorBlock: failureHandler)
        
    }
}
extension PlaceViewModel {
    
    // When data is fetched successfully with response code 200
    private func successHandler (data : Data) -> Void {
        
        do {
            let decoder = JSONDecoder()
            let list = try decoder.decode(PlaceModel.self, from: data)
            placeList = list
            if let successBlock = successBlock {
                successBlock(list)
                dataCacheManager.savePlaceInfoToDisk(info: list)
            }
    
        } catch let err {
            print("Error in decoding JSON \(err)")
            if let failureBlock = failureBlock {
                failureBlock(err)
            }
        }
        
    }
    
    // When there is an error in fetching road status eg. Http response code 404, Connectivity issue
    private func failureHandler(error : Error?) -> Void {
        
        print(error ?? "Unknown error in retrieving data")
        if let failureBlock = failureBlock {
            failureBlock(error)
        }
    }

}
