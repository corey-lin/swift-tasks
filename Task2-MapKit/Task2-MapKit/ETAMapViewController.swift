//
//  ETAMapViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 4/12/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit
import MapKit

class ETAMapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!

  var locationManager: CLLocationManager!

  override func viewDidLoad() {
    locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    mapView.showsUserLocation = true
  }

  @IBAction func nextPlace(sender: AnyObject) {
  }
}
