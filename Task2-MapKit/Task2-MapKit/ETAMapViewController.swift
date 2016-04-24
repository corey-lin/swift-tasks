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

    var annotation = CompanyAnnotation(coordinate: locationCoordinate)
    annotation.title = names[currentDestinationIndex]
    annotation.image = images[currentDestinationIndex]

    let request = MKDirectionsRequest()
    let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
    request.source = sourceItem
    let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: locationCoordinate, addressDictionary: nil))
    request.destination = destinationItem
    request.requestsAlternateRoutes = false
    request.transportType = .Transit
    mapView.setCenterCoordinate(locationCoordinate, animated: true)
    let directions = MKDirections(request: request)
    directions.calculateETAWithCompletionHandler() {
      (response: MKETAResponse?, error: NSError?) in
      if let error = error {
        print("Error while requesting ETA:\(error.localizedDescription)")
        annotation.eta = error.localizedDescription
      } else {
        let etaTime = Int((response?.expectedTravelTime)! / 60)
        annotation.eta = "\(etaTime)"
        print(annotation.eta)
      }
    }

    var isExist = false
    for a in mapView.annotations {
      if a.coordinate.latitude == locationCoordinate.latitude &&
        a.coordinate.longitude == locationCoordinate.longitude {
        isExist = true
        annotation = a as! CompanyAnnotation
      }
    }
    if !isExist {
      mapView.addAnnotation(annotation)
    }
    mapView.selectAnnotation(annotation, animated: true)
    currentDestinationIndex++
  }
}

extension ETAMapViewController: MKMapViewDelegate {

  func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpanMake(2, 2))
    mapView.setRegion(region, animated: true)
  }

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is CompanyAnnotation else {
      return nil
    }
    var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
      annotationView?.canShowCallout = true
    } else {
      annotationView?.annotation = annotation
    }
    let companyAnnotation = annotation as! CompanyAnnotation
    annotationView?.detailCalloutAccessoryView = UIImageView(image: companyAnnotation.image)
    let leftAccessory = UILabel(frame: CGRectMake(0, 0, 50, 30))
    leftAccessory.text = companyAnnotation.eta
    print(companyAnnotation.eta)
    leftAccessory.font = UIFont(name: "Verdana", size: 10)
    annotationView?.leftCalloutAccessoryView = leftAccessory
    let image = UIImage(named: "Bus")
    let button = UIButton(type: .Custom)
    button.frame = CGRectMake(0, 0, 30, 30)
    button.setImage(image, forState: .Normal)
    annotationView?.rightCalloutAccessoryView = button
    return annotationView
  }
}
