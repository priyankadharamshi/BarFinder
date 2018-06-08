//
//  PlaceModel.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import Foundation
import MapKit

struct PlaceModel: Codable {
    
    let nextPageToken: String?
    var places : [Place]
    
    private enum CodingKeys: String, CodingKey {
        
        case nextPageToken = "next_page_token"
        case places = "results"
    }
    
}

struct Place : Codable {
    
    var coordinate: CLLocationCoordinate2D {
        get {
            
            let coord = CLLocationCoordinate2D(latitude: geometry.location.lat , longitude: geometry.location.lng)
            return coord
        }
    }
    
    var placeName: String {
        get {
            return name
        }
    }
    var placeAddress: String {
        get {
            return vicinity
        }
    }
    
    let placeId : String
    
    private let geometry: Geometry
    
    private let icon, id, name: String
    private let photos: [Photo]?
    
    
    private let reference, scope: String
    private let types: [String]
    private let vicinity: String
    
    private enum CodingKeys: String, CodingKey {
        case geometry, icon, id, name, photos
        case placeId = "place_id"
        case reference, scope, types, vicinity
    }
    
}

private struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

private struct Location: Codable {
    let lat, lng: Double
}

private struct Viewport: Codable {
    let northeast, southwest: Location
}

private struct Photo: Codable {
    let height: Int
    let photoReference: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }
}
