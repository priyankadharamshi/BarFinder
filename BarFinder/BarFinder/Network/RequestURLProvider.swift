//
//  RequestURLProvider.swift
//  BarFinder
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import Foundation

struct RequestURLProvider {
    
    private let baseURLString = "https://maps.googleapis.com"
    private let mapsAPIString = "/maps/api/place/nearbysearch/json"

    var googleAPIURLString : String {
        get {
            return baseURLString + mapsAPIString
        }
    }
    
}
