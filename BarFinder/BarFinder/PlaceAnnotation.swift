//
//  PlaceAnnotations.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import Foundation
import MapKit
import Contacts

class PlaceAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName: String = "beer"
    
    init(withPlace : Place) {
        self.coordinate = withPlace.coordinate
        self.title = withPlace.placeName
        self.subtitle = withPlace.placeAddress
        
    }
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle ?? (title ?? "") ]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title ?? ""
        return mapItem
    }
}
