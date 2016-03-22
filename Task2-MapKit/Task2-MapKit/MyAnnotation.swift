//
//  MyAnnotation.swift
//  Task2-MapKit
//
//  Created by coreylin on 3/21/16.
//  Copyright © 2016 coreylin. All rights reserved.
//
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?

  init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
  }
}
