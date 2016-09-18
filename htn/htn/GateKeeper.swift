//
//  Gatekeeper.swift
//  htn
//
//  Created by Harry Liu on 2016-09-17.
//  Copyright © 2016 harryliu. All rights reserved.
//

import Foundation
import FMDB
import MapKit

class GateKeeper {

	var database: FMDatabase?

	var tableNames: [String] = ["AED_LOCATIONS",
	                            "AMBULANCE_LOCATIONS",
	                            "BIKE_SHOPS",
	                            "COMM_HOUSING",
	                            "CULTURAL_HOTSPOTS",
	                            "DRINKING_FOUNTAINS",
	                            "FIRE_STATIONS",
	                            "HOMELESS_SHELTERS",
	                            "LIBRARIES",
	                            "NBHD_BOUNDARIES",
	                            "NBHD_ECONOMICS",
	                            "NBHD_ETHNICITIES",
	                            "NBHD_SAFETY_INDICATORS",
	                            "POLICE_STATIONS",
	                            "RED_LIGHT_CAMERAS",
	                            "RENEWABLE_ENERGY",
	                            "RETIREMENT_HOMES",
	                            "SCHOOL_BOARD_LOCATIONS",
	                            "WORSHIP_PLACES"]

	func setup() {
		let path = Bundle.main.path(forResource: "htn", ofType: "db")
		database = FMDatabase(path: path)

		if let database = database, !database.open() {
			NSLog("Database error: cannot open")
		}
	}

	func getDict(from table: String) -> [String: String] {
		guard let db = database else {
			return [:]
		}
		guard let database = database, database.tableExists(table) else {
			return [:]
		}
		var dict = [String: String]()
		let resultSet = try! database.executeQuery("SELECT * FROM \(table)", values: [])
		while (resultSet.next()) {
			guard let coordinates = resultSet.string(forColumn: "COORDINATES") else {
				NSLog("Could not find coordinates column in database")
				return [:]
			}
			dict[coordinates] = "TEMP STRING"
		}
		print(dict)
		return dict
	}

	func getCoordinates(from table: String) -> [CLLocation] {
		let pattern = "^\\[(-?[0-9]*.?[0-9]*), (-?[0-9]*.?[0-9]*)\\]$"
		let dict = self.getDict(from: table)
		var array = [CLLocation]()
		for string in dict.keys {
			let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
			var result = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))

			var lat: CLLocationDegrees!
			var long: CLLocationDegrees!

			var range = result[0].rangeAt(1)
			if let swiftRange = range.range(for: string) {
				lat = CLLocationDegrees(string.substring(with: swiftRange))
			}

			range = result[1].rangeAt(1)
			if let swiftRange = range.range(for: string) {
				long = CLLocationDegrees(string.substring(with: swiftRange))
			}

			let location = CLLocation(latitude: lat, longitude: long)
			array.append(location)
		}
		return array
	}
}
