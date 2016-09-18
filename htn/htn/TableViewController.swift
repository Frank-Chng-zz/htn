//
//  TableViewController.swift
//  htn
//
//  Created by Harry Liu on 2016-09-18.
//  Copyright © 2016 harryliu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

	var selected = [Int]()

	var tableNames: [String] = ["AEDs",
	                            "Ambulances",
	                            "Bike Shops",
	                            "Communal Housing",
	                            "Cultural Hotspots",
	                            "Drinking Fountains",
	                            "Fire Stations",
	                            "Homeless Shelters",
	                            "Libraries",
	                            "Police Stations",
	                            "Red Light Cameras",
	                            "Renewable Energy",
	                            "Retirement Homes",
	                            "School Board Locations",
	                            "Worship Places"]

	var colourType: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = tableNames[indexPath.row]
		if selected.contains(indexPath.row) {
			cell.backgroundColor = self.colourType[self.selected.index(of: indexPath.row)!].withAlphaComponent(0.2)
		} else {
			cell.backgroundColor = UIColor.white
		}
        return cell
    }

	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if selected.contains(indexPath.row) {
			selected.remove(at: selected.index(of: indexPath.row)!)
		}
		else if selected.count < 6 {
			selected.append(indexPath.row)
		}
		tableView.reloadData()
		return nil
	}


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if let vc = segue.destination.childViewControllers[0] as? MainViewController {
			vc.active = self.selected
		}
    }


}
