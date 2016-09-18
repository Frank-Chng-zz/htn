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

	var colours = [String: UIColor]()

	var colourType: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]

	var overlays = [MKOverlay]()

	var active = [Int]()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.map.delegate = self

		self.setupGateKeeper()
		self.prepareView()
		self.setRegion()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func setupGateKeeper() {
		self.gateKeeper.setup()
	}

	func setupInformation(for index: Int, with colour: UIColor) {
		let information = self.gateKeeper.getCoordinates(from: self.gateKeeper.tableNames[index])
		print(String(describing: information.count))
		for location in information {
			self.addRadiusCircle(location: location, with: colour)
		}
	}

	func setRegion() {
		let latitude:CLLocationDegrees = 43.6532
		let longitude:CLLocationDegrees = -79.3832
		let latDelta:CLLocationDegrees = 0.3
		let lonDelta:CLLocationDegrees = 0.3
		let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
		let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
		let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)

		map.setRegion(region, animated: true)
	}

	func prepareView() {
		self.map.removeOverlays(self.map.overlays)
		for (position, index) in self.active.enumerated() {
			self.setupInformation(for: index, with: self.colourType[position])
		}
	}

	func addRadiusCircle(location: CLLocation, with colour: UIColor){
		let circle = MKCircle(center: location.coordinate, radius: Double(800) - Double(15 * active.count) as CLLocationDistance)
		self.colours[String(describing: location.coordinate)] = colour
		self.map.add(circle)
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKCircle {
			let circle = MKCircleRenderer(overlay: overlay)
			circle.fillColor = (colours[String(describing: overlay.coordinate)] ?? UIColor.clear).withAlphaComponent(0.2)
			return circle
		}
		return MKOverlayRenderer(overlay: overlay)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination.childViewControllers[0] as? TableViewController {
			vc.selected = self.active
		}
	}
}
