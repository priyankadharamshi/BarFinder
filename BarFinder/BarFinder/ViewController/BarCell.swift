//
//  BarCell.swift
//  BarFinder
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import UIKit

class BarCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    func updateBarDetails(place : Place) {
        
        self.textLabel?.text = place.placeName
        self.detailTextLabel?.text = place.placeAddress
    }
}
