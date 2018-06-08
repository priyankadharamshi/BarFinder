//
//  PlaceModelTests.swift
//  BarFinderTests
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import XCTest
@testable import BarFinder

class PlaceModelTests: XCTestCase {
    
    var placeModel : PlaceModel?
    var objectUnderTest : Place?
    
    override func setUp() {
        super.setUp()
       
        initialisePlaceModelFromJSONFile()
        objectUnderTest = placeModel?.places.first
        
        XCTAssertTrue(objectUnderTest != nil,"Place object cannot be nil")
        
    }
    override func tearDown() {
      
        objectUnderTest = nil
        placeModel = nil
        super.tearDown()
    }
    
    func test_placeMockExists() {
        
        let place = objectUnderTest
        XCTAssertTrue(place != nil,"Place object exists")
    }
    
    func test_placeIdExists() {
        
        let placeId = objectUnderTest?.placeId
        XCTAssertEqual(placeId, "ChIJ5QKI1Duo2EcR12zVZnRnxpI")
    }
    func test_placeNameExists() {
        
        let placeName = objectUnderTest?.placeName
        XCTAssertEqual(placeName, "Angerstein Hotel")
    }
    func test_placeAddressExists() {
        
        let placeAddress = objectUnderTest?.placeAddress
        XCTAssertEqual(placeAddress, "108 Woolwich Road, London")
    }
    
    func test_placeCoordinateExists() {
        
        let latitude = objectUnderTest?.coordinate.latitude
        XCTAssertEqual(latitude, 51.4863488)
        
    }
    
    
}
extension PlaceModelTests {
    
    private func initialisePlaceModelFromJSONFile() {
        
        if let path = Bundle.main.path(forResource: "BarResult", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let placeList = try decoder.decode(PlaceModel.self, from: data)
                
                placeModel = placeList
                
            } catch  {
                print("Error in decoding JSON \(error)")
                
            }
        }
    }
}
