//
//  XCUIController.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 03/01/2023.
//

import XCTest

/// Provides an interface that facilitates controlling the SUT.
protocol XCUIController {
	associatedtype ButtonType
	
	var app: XCUIApplication { get }
	
	func press(_ buttonType: ButtonType)
}

protocol XCUITextInputController: XCUIController {
	associatedtype InputType
	
	func enter(_ text: String, in inputType: InputType)
	func dismissKeyboard()
}

extension XCUITextInputController {
	func dismissKeyboard() {
		app.toolbars.buttons[.ui.done].tap()
	}
}

protocol XCUISwitchController: XCUIController {
	associatedtype SwitchType
	
	func toggle(_ buttonType: SwitchType)
}
