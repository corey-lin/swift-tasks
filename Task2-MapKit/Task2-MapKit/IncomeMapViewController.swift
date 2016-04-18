//
//  IncomeMapViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 3/24/16.
//  Copyright © 2016 coreylin. All rights reserved.
//
import UIKit
import MapKit

class IncomeMapViewController: UIViewController {
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var areaListBtn: UIBarButtonItem!
  var contentController: UITableViewController!
  var selectedItemIndex: Int!
  let regionNames = [
    "Africa",
    "East Asia and the Pacific",
    "Central Europe and the Baltics",
    "Europe and Central Asia",
    "Latin America and the Caribbean",
    "Middle East and North Africa",
    "South Asia",
    "European Union",
    "North America",
    "North Africa",
    "South Asia II"
  ]

  let regionCodes = [
    "AFR",
    "CEA",
    "CEB",
    "CEU",
    "CLA",
    "CME",
    "CSA",
    "EUU",
    "NAC",
    "NAF",
    "SAS",
  ]

// MARK: - Life Cycle

  override func viewDidLoad() {
    contentController = UITableViewController()
    contentController.tableView.dataSource = self
    contentController.tableView.delegate = self
    mapView.delegate = self
    selectedItemIndex = -1
  }

// MARK: -

  @IBAction func showAreaList(sender: AnyObject) {
    contentController.modalPresentationStyle = .Popover
    let popoverController = contentController.popoverPresentationController
    popoverController?.barButtonItem = areaListBtn
    popoverController?.delegate = self
    selectedItemIndex = -1
    contentController.tableView.reloadData()
    presentViewController(contentController, animated: true, completion: nil)
  }

// MARK: -

  func done() {
    dismissViewControllerAnimated(true, completion: nil)
    if mapView.annotations.count != 0 {
      mapView.removeAnnotations(mapView.annotations)
    }
    mapSearch()
  }

  func mapSearch() {
    guard selectedItemIndex != -1 else {
      return
    }
    let url = NSURL(string: "http://api.worldbank.org/country?per_page=100&region=\(regionCodes[selectedItemIndex])&format=json")
    let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
      (data: NSData?, response: NSURLResponse?, error: NSError?) in
      guard data != nil else {
        return
      }
      do{
        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [AnyObject]
        let data = json[1] as! [AnyObject]
        dispatch_async(dispatch_get_main_queue()) {
          self.handleBankData(data)
        }
      } catch {
        print("Error: JSON")
      }
    }
    task.resume()
  }

  func handleBankData(data: [AnyObject]) {
    guard data.count > 0 else {
      return
    }
    let cityInfo = data[0] as! Dictionary<String, AnyObject>
    let location = CLLocationCoordinate2D(latitude: Double(cityInfo["latitude"] as! String)!, longitude: Double(cityInfo["longitude"] as! String)!)
    let span = MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
    let region = MKCoordinateRegionMake(location, span)
    mapView.setRegion(region, animated: true)

    for item in data {
      let pinAnnotation = SalaryLevelAnnotation()
      let incomeLevel = item["incomeLevel"] as! Dictionary<String, AnyObject>
      if let level = incomeLevel["value"] {
        let levelString = level as! String
        if levelString == "High income: OECD" || levelString == "High income: nonOECD" {
          pinAnnotation.imageName = "High income"
        }else{
          pinAnnotation.imageName = (incomeLevel["value"] as! String)
        }
      }
      pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(item["latitude"] as! String)!, longitude: Double(item["longitude"] as! String)!)
      pinAnnotation.title = item["name"] as? String
      pinAnnotation.subtitle = item["capitalCity"] as? String
      mapView.addAnnotation(pinAnnotation)
    }
  }
}

extension IncomeMapViewController: UITableViewDataSource, UITableViewDelegate {

// MARK: - UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return regionNames.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("regionCell")
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: "regionCell")
    }
    cell?.textLabel?.text = regionNames[indexPath.row]
    cell?.accessoryType = .None
    return cell!
  }

// MARK: - UITableViewDelegate

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark
    selectedItemIndex = indexPath.row
  }

  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .None
  }
}

extension IncomeMapViewController: UIPopoverPresentationControllerDelegate {

// MARK: - UIPopoverPresentationControllerDelegate

  func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
    done()
  }

  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .FullScreen
  }

  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    let navController = UINavigationController(rootViewController: controller.presentedViewController)
    controller.presentedViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done"))
    return navController
  }
}

extension IncomeMapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is SalaryLevelAnnotation {
      let levelAnnotation = annotation as! SalaryLevelAnnotation
      var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("level")
      if annotationView == nil {
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "level")
      }
      annotationView?.annotation = annotation
      annotationView?.image = UIImage(named: levelAnnotation.imageName)
      annotationView?.canShowCallout = true
      return annotationView
    } else {
      return nil
    }
  }
}
