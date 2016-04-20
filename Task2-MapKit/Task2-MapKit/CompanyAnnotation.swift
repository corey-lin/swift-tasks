//
//  CompanyAnnotation.swift
//  Task2-MapKit
//
//  Created by coreylin on 4/20/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit
import MapKit

class CompanyAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var image: UIImage?
  var eta: String?
  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }
}
