//
//  ViewController.swift
//  htn
//
//  Created by Jordan Lee on 2016-09-17.
//  Copyright © 2016 Jordan Lee. All rights reserved.
//

import UIKit
import DTMHeatmap
import MapKit


enum MapType: Int {
    case Standard = 0
    case Hybrid
    case Satellite
}

class ViewController: UIViewController, MKMapViewDelegate {

    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    lazy var heatMap: DTMHeatmap = {
        return DTMHeatmap();
    }()
    
    func readFromTextFile() -> [String]? {
        let file = "mcdonalds"
        
        guard let optionalPath = Bundle.main.path(forResource: file, ofType: "txt") else {
            NSLog("Couldn't get path");
            return nil
        }
        do {
            let content = try String(contentsOfFile: optionalPath, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
    
        } catch _ as Error {
            return nil
        }
    }
    
    /*
     * Provide data in the form of a dictionary mapping MKMapPoint (wrapped in NSValue using [NSValue value:&point withObjCType:@encode(MKMapPoint)]) to weights
     */
    func getDataSet() -> [AnyHashable: Any] {
        
        var dataSet: [AnyHashable: Any] = [:]
        
        let stringArray: [String]? = readFromTextFile()
        
        if (stringArray != nil) {
            
            for line in stringArray! {
                
                let parts: [String] = line.components(separatedBy: ",")
                let latStr: String = parts[0]
                let lonStr: String = parts[1]
                
                let lat: CLLocationDegrees = Double(latStr)!
                let lon: CLLocationDegrees = Double(lonStr)!
                
                let location: CLLocation = CLLocation.init(latitude: lat, longitude: lon);
                
                var point: MKMapPoint = MKMapPointForCoordinate(location.coordinate);
                
                
                // FOLLOWING 2 lines do not work. Only 1 key/value pair is ever created
                let key = NSValue(pointer: &point)
                dataSet[key as! NSValue] = 1;

            }
        } else {
            NSLog("String array was null")
        }
        
        return dataSet
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove current overlays
        var overlays = self.mapView.overlays;
        for overlay in overlays {
            NSLog("removed overlay")
            mapView.remove(overlay)
        }
        
        // remove annotations
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        
        // default to standard
        mapView.mapType = MKMapType.standard
        
        
        
      
        // Sets visible region to Toronto area
        let startCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(43.6532, -79.3832);
        let adjustedRegion: MKCoordinateRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(startCoord, 50000, 50000))
        mapView.setRegion(adjustedRegion, animated: true)
        
        // Get rid of POI
        mapView.showsPointsOfInterest = false
        mapView.showsBuildings = false
        
    
        heatMap.setData(getDataSet())
        //let overlay: MKOverlay = MKOverlay
        
        mapView.add(heatMap)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        NSLog("Hello World!")

        if let location = userLocation.location {
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        NSLog("Rendering for overlay")
        return DTMHeatmapRenderer(overlay: overlay)
    }
    
    
    // Called when 'options' menu item is pressed
    @IBAction func onButtonPressed() {
        NSLog("ON BUTTON PRESSED")
        let viewController = TableViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

