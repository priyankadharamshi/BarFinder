//
//  PlaceAnnotationsTests.swift
//  BarFinderTests
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import XCTest
@testable import BarFinder

class PlaceAnnotationTests: XCTestCase {
    
    var place: Place?
    var objectUnderTest : PlaceAnnotation?
    
    override func setUp() {
        super.setUp()
        
        initialisePlaceFromJSONFile()
        
        if let place = place {
            objectUnderTest = PlaceAnnotation.init(withPlace: place)
        }
        XCTAssertTrue(objectUnderTest != nil,"Place object cannot be nil")
        
    }
    override func tearDown() {
        
        objectUnderTest = nil
        place = nil
        super.tearDown()
    }
    
    func test_annotationMockExists() {
        
        let place = objectUnderTest
        XCTAssertTrue(place != nil,"Place object exists")
    }

    func test_annotationTitleExists() {
        
        let placeName = objectUnderTest?.title
        XCTAssertEqual(placeName, "Angerstein Hotel")
    }
    func test_placeSubtitleExists() {
        
        let placeAddress = objectUnderTest?.subtitle
        XCTAssertEqual(placeAddress, "108 Woolwich Road, London")
    }
    
    func test_placeCoordinateExists() {
        
        let latitude = objectUnderTest?.coordinate.latitude
        XCTAssertEqual(latitude, 51.4863488)
        
    }
    
    
}
extension PlaceAnnotationTests {
    
    private func initialisePlaceFromJSONFile() {
        
        if let path = Bundle.main.path(forResource: "BarResult", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let placeList = try decoder.decode(PlaceModel.self, from: data)
                
                place = placeList.places.first
                
            } catch  {
                print("Error in decoding JSON \(error)")
                
            }
        }
    }
}
