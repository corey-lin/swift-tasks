//
//  IncomeMapViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 3/24/16.
//  Copyright © 2016 coreylin. All rights reserved.
//
import UIKit
import MapKit

class IncomeMapViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource,
  UITableViewDelegate {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var areaListBtn: UIBarButtonItem!
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
    "South Asia"
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

// MARK: -

  func done() {
    dismissViewControllerAnimated(true, completion: nil)
    mapSearch()
  }

  func mapSearch() {

  }
}
