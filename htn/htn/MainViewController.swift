//
//  MainViewController.swift
//  htn
//
//  Created by Harry Liu on 2016-09-17.
//  Copyright © 2016 harryliu. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

	@IBOutlet weak var map: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let location = CLLocation(latitude: 46.7667 as CLLocationDegrees, longitude: 23.58 as CLLocationDegrees)
		addRadiusCircle(location: location)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func display(theseNodes nodes: [CLLocationCoordinate2D]) {
		_ = nodes.map { [weak self] in self?.display(node: $0) }
	}

	func display(node: CLLocationCoordinate2D) {

	}

	func addRadiusCircle(location: CLLocation){
		let circle = MKCircle(center: location.coordinate, radius: 100000 as CLLocationDistance)
		self.map.add(circle)
	}

	func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
		if overlay is MKCircle {
			let circle = MKCircleRenderer(overlay: overlay)
			circle.strokeColor = UIColor.red
			circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1.0)
			circle.lineWidth = 1
			return circle
		} else {
			return nil
		}
	}
}

