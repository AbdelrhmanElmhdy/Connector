//
//  SignupScreenController.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 03/01/2023.
//

import Foundation
import XCTest

class SignupScreenXCUIController: XCUITextInputController {
	enum ButtonType {
		case createAccountButton
		case loginButton
	}
	
	enum InputType {
		case firstNameInput
		case lastNameInput
		case emailInput
		case usernameInput
		case passwordInput
		case confirmPasswordInput
	}
	
	// MARK: Properties
	
	let app: XCUIApplication
	private lazy var elementQuery = app.scrollViews.otherElements
	
	// MARK: Buttons
	
	private lazy var createAccountButton = elementQuery.buttons[.ui.createAccountBtnTitle]
	private lazy var loginButton = elementQuery.buttons[.ui.login]
	
	// MARK: Inputs
	
	private lazy var firstNameInput = elementQuery.textFields[.ui.firstNameTextFieldPlaceholder]
	private lazy var lastNameInput = elementQuery.textFields[.ui.lastNameTextFieldPlaceholder]
	private lazy var emailInput = elementQuery.textFields[.ui.email]
	private lazy var usernameInput = elementQuery.textFields[.ui.username]
	private lazy var passwordInput = elementQuery.textFields[.ui.password]
	private lazy var confirmPasswordInput = elementQuery.textFields[.ui.confirmPasswordTextFieldPlaceholder]
	
	// MARK: Initialization
	
	/// - Note: The app must be navigated to the signup screen before initialization
	init(app: XCUIApplication) {
		self.app = app
		let signupScreenIsVisible = elementQuery.staticTexts[.ui.alreadyHaveAccountLabel].waitForExistence(timeout: 2)
		
		if !signupScreenIsVisible {
			XCTFail("Attempting to initialize a signup screen controller before navigating to signup screen")
		}
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
		case .firstNameInput: return firstNameInput
		case .lastNameInput: return lastNameInput
		case .emailInput: return emailInput
		case .usernameInput: return usernameInput
		case .passwordInput: return passwordInput
		case .confirmPasswordInput: return confirmPasswordInput
		}
	}
	
	private func getButton(ofType signupButtonType: ButtonType) -> XCUIElement {
		switch signupButtonType {
		case .createAccountButton: return createAccountButton
		case .loginButton: return loginButton
		}
	}
}
