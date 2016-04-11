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
    mapView.delegate = self
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
    mapView.removeOverlays(mapView.overlays)
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let circle = MKCircle(centerCoordinate: coordinate, radius: 200000)
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 800000, 800000), animated: true)
    mapView.addOverlay(circle)
  }
}

extension RegionMapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    if let circle = overlay as? MKCircle {
      let circleRenderer = MKCircleRenderer(circle: circle)
      circleRenderer.fillColor = UIColor.redColor().colorWithAlphaComponent(0.1)
      circleRenderer.strokeColor = UIColor.redColor()
      circleRenderer.lineWidth = 1
      return circleRenderer
    } else {
      return MKOverlayRenderer(overlay: overlay);
    }
  }
}
