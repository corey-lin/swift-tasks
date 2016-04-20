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

  var currentDestinationIndex = 0
  let coordinates = [
    [37.4848474,-122.1505746],
    [37.4220005,-122.0845547]
  ]
  let names = ["Facebook HQ", "Google HQ"]
  var images: [UIImage]!
  var locationManager: CLLocationManager!

  override func viewDidLoad() {
    images = [UIImage(named: "FacebookIcon")!, UIImage(named: "GoogleIcon")!]
    locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    mapView.showsUserLocation = true
    mapView.delegate = self
  }

  @IBAction func nextPlace(sender: AnyObject) {
    if currentDestinationIndex > names.count - 1 {
      currentDestinationIndex = 0;
    }
    let coordinate = coordinates[currentDestinationIndex]
    let latitude = coordinate[0]
    let longitude = coordinate[1]
    let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

    let annotation = CompanyAnnotation(coordinate: locationCoordinate)
    annotation.title = names[currentDestinationIndex]
    annotation.image = images[currentDestinationIndex]
  }
}

extension ETAMapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpanMake(2, 2))
    mapView.setRegion(region, animated: true)
  }
}
