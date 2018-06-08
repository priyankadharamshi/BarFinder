//
//  DataCache.swift
//  BarFinder
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import Foundation

class DataCache {
    
    
    // MARK: Save objects to local disk.
    
    //Save place object
    func savePlaceInfoToDisk(info: PlaceModel) {
        // 1. Create a URL for documents-directory/posts.json
        let url = getDocumentsURL().appendingPathComponent("placeModel.json")
        // 2. Endcode our [Post] data to JSON Data
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(info)
            // 3. Write this data to the url specified in step 1
            try data.write(to: url, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    //Retreive place object
    func getPlaceInfoFromDisk() -> PlaceModel? {
        // 1. Create a url for documents-directory/posts.json
        let url = getDocumentsURL().appendingPathComponent("placeModel.json")
        let decoder = JSONDecoder()
        do {
            // 2. Retrieve the data on the file in this path (if there is any)
            let data = try Data(contentsOf: url, options: [])
            // 3. Decode from this Data
            let info = try decoder.decode(PlaceModel.self, from: data)
            return info
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    private func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
}
    
    


