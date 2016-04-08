//
//  RegionListViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 4/6/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit

protocol RegionsProtocol {
  func loadOverlayForRegionWithLatitude(latitude: Double, andLongitude longitude: Double)
}

class RegionListViewController: UIViewController {
  @IBOutlet weak var regionList: UITableView!
  var delegate: RegionsProtocol?
  var selectFinished: (() -> (Void))?
  var regions = ["Verkhoyansk (Russia)","Fraser, Colo (United States)","Hell (Norway)","Barrow (Alaska)","Oymyakon (Russia)"]
  var latitudes = [67.550592,39.944987,63.445171,71.290556,63.464138]
  var longitudes = [133.399340,-105.817232,10.905217,-156.788611,142.773727]

  override func viewDidLoad() {
    regionList.delegate = self;
    regionList.dataSource = self;
  }
}

extension RegionListViewController: UITableViewDataSource, UITableViewDelegate {

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

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    delegate?.loadOverlayForRegionWithLatitude(latitudes[indexPath.row], andLongitude: longitudes[indexPath.row])
    selectFinished?()
  }
}
