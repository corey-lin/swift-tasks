//
//  PinDetailsViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 3/23/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import MapKit

class PinDetailsViewController: UIViewController, UITableViewDataSource {
  @IBOutlet var tableView: UITableView!

  var mapItemData: MKMapItem!

  //MARK: - Life Cycle

  override func viewDidLoad() {
    tableView.dataSource = self
  }

  //MARK: - UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("detailCell")

    if cell == nil {
      cell = UITableViewCell(style: .Value1, reuseIdentifier: "detailCell")
    }
    switch indexPath.row {
    case 0:
      cell?.textLabel?.text = mapItemData.name
    case 1:
      cell?.textLabel?.text = mapItemData.placemark.country
      cell?.detailTextLabel?.text = mapItemData.placemark.countryCode
    case 2:
      cell?.textLabel?.text = mapItemData.placemark.postalCode
    case 3:
      cell?.textLabel?.text = "Phone number"
      cell?.detailTextLabel?.text = mapItemData.phoneNumber
    default:
      cell?.textLabel?.text = "Unknown"
    }
    return cell!
  }
}
