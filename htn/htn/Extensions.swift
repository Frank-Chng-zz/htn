//
//  Extensions.swift
//  htn
//
//  Created by Harry Liu on 2016-09-18.
//  Copyright © 2016 harryliu. All rights reserved.
//

import Foundation

extension NSRange {
	func range(for str: String) -> Range<String.Index>? {
		guard location != NSNotFound else { return nil }

		guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
		guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
		guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
		guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }

		return fromIndex ..< toIndex
	}
}
