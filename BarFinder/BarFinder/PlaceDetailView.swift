//
//  PlaceDetailView.swift
//  BarFinder
//
//  Created by Priyanka  on 06/06/18.
//  Copyright © 2018 Priyanka. All rights reserved.
//

import Foundation
import MapKit

class PlaceDetailView: MKAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let artwork = newValue as? PlaceAnnotation else {return}

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
        size: CGSize(width: 30, height: 30)))
      mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
      rightCalloutAccessoryView = mapsButton
        
      if artwork.imageName.count > 0 {
        image = UIImage(named: artwork.imageName)
      } else {
        image = nil
      }
        
      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailLabel.text = artwork.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }

}

