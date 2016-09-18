//
//  MainViewController.swift
//  htn
//
//  Created by Harry Liu on 2016-09-17.
//  Copyright © 2016 harryliu. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var map: MKMapView!

	let gateKeeper = (UIApplication.shared.delegate as! AppDelegate).gateKeeper

	override func viewDidLoad() {
		super.viewDidLoad()

		self.map.delegate = self

		self.setupGateKeeper()
		self.setupInformation()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func setupGateKeeper() {
		self.gateKeeper.setup()
	}

	func setupInformation() {
		let information = self.gateKeeper.getCoordinates(from: self.gateKeeper.tableNames[0])
		for datum in information {
			self.addRadiusCircle(location: datum)
		}
	}

	func display(theseNodes nodes: [CLLocationCoordinate2D]) {
		_ = nodes.map { [weak self] in self?.display(node: $0) }
	}

	func display(node: CLLocationCoordinate2D) {
		
	}

	func addRadiusCircle(location: CLLocation){
		let circle = MKCircle(center: location.coordinate, radius: 100 as CLLocationDistance)
		self.map.add(circle)
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKCircle {
			let circle = MKCircleRenderer(overlay: overlay)
			circle.strokeColor = UIColor.red
			circle.fillColor = UIColor(red: 100, green: 0, blue: 0, alpha: 0.4)
			circle.lineWidth = 2
			return circle
		}
		return MKOverlayRenderer(overlay: overlay)
	}
}

