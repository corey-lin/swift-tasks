//
//  RegionMapViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 4/1/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import MapKit

class RegionMapViewController: UIViewController {
  var regionList: UITableViewController!
  var regions = ["Verkhoyansk (Russia)","Fraser, Colo (United States)","Hell (Norway)","Barrow (Alaska)","Oymyakon (Russia)"]
  var latitudes = [67.550592,39.944987,63.445171,71.290556,63.464138]
  var longitudes = [133.399340,-105.817232,10.905217,-156.788611,142.773727]
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchBarItem: UIBarButtonItem!
  
  @IBAction func searchRegion(sender: AnyObject) {
    regionList.modalPresentationStyle = .Popover
    let popoverController = regionList.popoverPresentationController
    popoverController?.barButtonItem = searchBarItem
    presentViewController(regionList, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    regionList = UITableViewController()
    regionList.tableView.delegate = self
    regionList.tableView.dataSource = self
  }
}

extension RegionMapViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return regions.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("regionCell")
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: "regionCell")
    }
    cell?.textLabel?.text = regions[indexPath.row]
    return cell!
  }
}
