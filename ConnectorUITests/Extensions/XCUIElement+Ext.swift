//
//  XCUIElement+Ext.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 21/12/2022.
//

import XCTest

extension XCUIElement {
	private func clearText() {
		guard let stringValue = self.value as? String else {
			XCTFail("Tried to clear and enter text into a non string value")
			return
		}
		
		guard !stringValue.isEmpty else { return }
		
		let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
		
		self.typeText(deleteString)
	}
	
	/// Taps the textField and removes any current text in the field before typing in the new value.
	/// - Parameter text: The text to enter into the field
	func enterText(text: String) {
		self.tap()
		self.clearText()
		self.typeText(text)
	}
	
	func contains(_ text: String) -> Bool {
		self.staticTexts[text].exists
	}
	
	func contains(_ text: String, waitFor timeout: TimeInterval?) -> Bool {
		guard let timeout = timeout else { return self.contains(text) }
		return self.staticTexts[text].waitForExistence(timeout: timeout)
	}
}
