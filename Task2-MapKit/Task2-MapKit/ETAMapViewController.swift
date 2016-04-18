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
  @IBOutlet var mapView: MKMapView!

  let coordinates = [
    [37.4848474,-122.1505746],
    [37.4220005,-122.0845547]
  ]
  let names = ["Facebook HQ", "Google HQ"]
  var locationManager: CLLocationManager!

  override func viewDidLoad() {
    locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    mapView.showsUserLocation = true
    mapView.delegate = self
  }

  @IBAction func nextPlace(sender: AnyObject) {
  }
}

extension ETAMapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpanMake(2, 2))
    mapView.setRegion(region, animated: true)
  }
}
