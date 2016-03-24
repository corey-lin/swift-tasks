//
//  ViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 3/20/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var showOptionBtn: UIBarButtonItem!
  var contentController: UITableViewController!
  var mapType: UISegmentedControl!
  var showPOI: UISwitch!
  var mapItemData: MKMapItem!

  @IBAction func showMapOptions(sender: AnyObject) {
    contentController.tableView.dataSource = self
    contentController.modalPresentationStyle = .Popover
    let popPC = contentController.popoverPresentationController!
    popPC.barButtonItem = showOptionBtn
    popPC.delegate = self
    presentViewController(contentController, animated: true, completion: nil)
  }
  @IBAction func showSearchBar(sender: AnyObject) {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    presentViewController(searchController, animated: true, completion: nil)
  }

  override func loadView() {
    super.loadView()
    mapType = UISegmentedControl(items:["Standard", "Satellite", "Hybrid"])
    showPOI = UISwitch()
    contentController = UITableViewController()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    mapView.delegate = self
    contentController.tableView.dataSource = self
    mapType.selectedSegmentIndex = 0
    showPOI.on = mapView.showsPointsOfInterest
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.dismissViewControllerAnimated(true, completion: nil)
    if mapView.annotations.count != 0 {
      mapView.removeAnnotations(self.mapView.annotations)
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

      let pinPoint = CLLocationCoordinate2D(latitude: response.mapItems.last!.placemark.coordinate.latitude,
                                           longitude: response.mapItems.last!.placemark.coordinate.longitude)
      let myAnnotation = MyAnnotation(coordinate: pinPoint, title: searchBar.text, subtitle: nil)
      let region = MKCoordinateRegionMakeWithDistance(pinPoint, 3000, 3000)
      self.mapView.centerCoordinate = pinPoint
      self.mapView.setRegion(region, animated: true)
      self.mapView.addAnnotation(myAnnotation)
      self.mapItemData = response.mapItems.last
    })
  }

// MARK: - MKMapViewDelegate

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MyAnnotation {
      var myAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("MyPinView")
      if myAnnotationView == nil {
        myAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MyPinView")
        let image = UIImage(named: "logo")
        myAnnotationView?.image = UIImage(CGImage: (image?.CGImage)!, scale: 5, orientation: .Up)
        myAnnotationView?.rightCalloutAccessoryView = UIButton(type: .InfoLight)
        myAnnotationView?.canShowCallout = true
      }
      return myAnnotationView
    } else {
      return nil
    }
  }

  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    performSegueWithIdentifier("pinDetails", sender: nil)
  }

// MARK: - UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell:UITableViewCell!
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
    }
    if indexPath.row == 0 {
      cell = tableView.dequeueReusableCellWithIdentifier("cellMapType")
      if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: "cellMapType")
      }
      mapType.center = cell.center
      cell.addSubview(mapType)
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("cellShowPOI")
      if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: "cellShowPOI")
      }
      cell.textLabel?.text = "Show Point Of Interest"
      cell.accessoryView = showPOI
    }
    return cell;
  }

// MARK: - UIPopoverPresentationControllerDelegate

  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .FullScreen
  }

  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    let navController = UINavigationController(rootViewController: controller.presentedViewController)
    controller.presentedViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
    return navController
  }

  func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
    done()
  }

// MARK: - Dismiss Popover

  func done() {
    presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    mapView.showsPointsOfInterest = showPOI.on
    switch mapType.selectedSegmentIndex {
    case 0:
      mapView.mapType = .Standard
    case 1:
      mapView.mapType = .Hybrid
    case 2:
      mapView.mapType = .Satellite
    default:
      mapView.mapType = .Standard
    }
  }

// MARK: -

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let pinDetailsVC = segue.destinationViewController as! PinDetailsViewController
    pinDetailsVC.mapItemData = mapItemData
  }
}

