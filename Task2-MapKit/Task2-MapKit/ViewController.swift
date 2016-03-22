//
//  ViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 3/20/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
  @IBOutlet weak var mapView: MKMapView!

  @IBAction func showSearchBar(sender: AnyObject) {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    presentViewController(searchController, animated: true, completion: nil)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.dismissViewControllerAnimated(true, completion: nil)
    if self.mapView.annotations.count != 0 {
      self.mapView.removeAnnotations(self.mapView.annotations)
    }

    let localSearchRequest = MKLocalSearchRequest()
    localSearchRequest.naturalLanguageQuery = searchBar.text
    let localSearch = MKLocalSearch(request: localSearchRequest)
    localSearch.startWithCompletionHandler({
      response, error in
      guard let response = response else {
        let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        return
      }

      let pinPoint = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude,
                                           longitude: response.boundingRegion.center.longitude)
      let myAnnotation = MyAnnotation(coordinate: pinPoint, title: searchBar.text, subtitle: nil)
      let region = MKCoordinateRegionMakeWithDistance(pinPoint, 3000, 3000)
      self.mapView.centerCoordinate = pinPoint
      self.mapView.setRegion(region, animated: true)
      self.mapView.addAnnotation(myAnnotation)
    })
  }
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MyAnnotation {
      var myAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("MyPinView")
      if myAnnotationView == nil {
        myAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MyPinView")
        let image = UIImage(named: "logo")
        myAnnotationView?.image = UIImage(CGImage: (image?.CGImage)!, scale: 5, orientation: .Up)
        myAnnotationView?.canShowCallout = true
      }
      return myAnnotationView
    } else {
      return nil
    }
  }
}

