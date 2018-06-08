//
//  PlaceViewModelTests.swift
//  BarFinderTests
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import XCTest
import CoreLocation
@testable import BarFinder

class PlaceViewModelTests: XCTestCase {
    
    var objectUnderTest : MockPlaceViewModel?

    override func setUp() {
        super.setUp()
        
        objectUnderTest = MockPlaceViewModel()
        
    }
    
    override func tearDown() {
        
        objectUnderTest = nil
        
        super.tearDown()
    }
    
    func test_placeViewModelMockExists() {
        
        let mockViewModel = objectUnderTest
        XCTAssertTrue(mockViewModel != nil,"Place View Model object exists")
    }
    
    func test_mockPlaceExists() {
        
        let location = CLLocationCoordinate2DMake(50.0, 0.013)
        objectUnderTest?.fetchBars(nearCoordinate: location, completionBlock: { (placeModel) -> Void in
            
        }, errorBlock: { (error) -> Void in
            
        })
        
        XCTAssertEqual(objectUnderTest?.placeList?.places.count,1)
      
   
    }
    
}
