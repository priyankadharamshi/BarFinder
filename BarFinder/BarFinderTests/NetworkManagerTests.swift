//
//  NetworkManagerTests.swift
//  BarFinderTests
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import XCTest
import CoreLocation

@testable import BarFinder

class NetworkManagerTests: XCTestCase {
    
    var objectUnderTest : MockNetworkManager?
    
    override func setUp() {
        super.setUp()
        
        objectUnderTest = MockNetworkManager()
        
    }
    
    override func tearDown() {
        
        objectUnderTest = nil
        
        super.tearDown()
    }
    
    func test_networkManagerExists() {
        
        let networkManager = objectUnderTest
        XCTAssertTrue(networkManager != nil,"Network manager object exists")
    }
    
    func test_mockPlaceExists() {
        
        let location = CLLocationCoordinate2DMake(50.0, 0.013)
        objectUnderTest?.fetchPlaces(nearCoordinate: location, completionBlock: { (data) in
            
        }, errorBlock: { (error) in
            
        })
        
        XCTAssertTrue(objectUnderTest?.resultData != nil,"Result data exists")
        
    }
   
}
