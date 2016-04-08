//
//  RegionMapViewController.swift
//  Task2-MapKit
//
//  Created by coreylin on 4/1/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import MapKit

class RegionMapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!

  override func viewDidLoad() {

  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController is RegionListViewController {
      let regionList = segue.destinationViewController as! RegionListViewController
      regionList.delegate = self
      regionList.selectFinished = {
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
}

extension RegionMapViewController: RegionsProtocol {
  func loadOverlayForRegionWithLatitude(latitude: Double, andLongitude longitude: Double) {
    print("\(latitude) \(longitude)")
  }
}
