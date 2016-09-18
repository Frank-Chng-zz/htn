//
//  Gatekeeper.swift
//  htn
//
//  Created by Harry Liu on 2016-09-17.
//  Copyright © 2016 harryliu. All rights reserved.
//

import Foundation
import SQLite

class GateKeeper {

	var database: Connection?

	func setup() {
		database = try? Connection("path/to/db.sqlite3")
	}

	func getDictFrom(table: String) -> [String: String] {
		return [:]
	}
}
