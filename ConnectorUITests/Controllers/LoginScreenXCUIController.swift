//
//  LoginScreenXCUIController.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 03/01/2023.
//

import Foundation
import XCTest

class LoginScreenXCUIController: XCUITextInputController {
	enum ButtonType {
		case loginButton
		case createAccountButton
	}
	
	enum InputType {
		case emailInput
		case passwordInput
	}
	
	// MARK: Properties
	
	let app: XCUIApplication
	private lazy var elementQuery = app.scrollViews.otherElements
	
	// MARK: Buttons
	
	private lazy var createAccountButton = elementQuery.buttons[.ui.createAccountSuggestionBtnTitle]
	private lazy var loginButton = elementQuery.buttons[.ui.login]
	
	// MARK: Inputs
	
	private lazy var emailInput = elementQuery.textFields[.ui.email]
	private lazy var passwordInput = elementQuery.textFields[.ui.password]
	
	// MARK: Initialization
	
	init(app: XCUIApplication) {
		self.app = app
	}
	
	// MARK: XCUIController Interface
	
	func enter(_ text: String, in inputType: InputType) {
		let input = getInput(ofType: inputType)
		input.enterText(text: text)
	}
	
	func press(_ buttonType: ButtonType) {
		getButton(ofType: buttonType).tap()
	}
	
	// MARK: Convenience
	
	private func getInput(ofType signupInputType: InputType) -> XCUIElement {
		switch signupInputType {
		case .emailInput: return emailInput
		case .passwordInput: return passwordInput
		}
	}
	
	private func getButton(ofType loginButtonType: ButtonType) -> XCUIElement {
		switch loginButtonType {
		case .createAccountButton: return createAccountButton
		case .loginButton: return loginButton
		}
	}
}
