//
//  SignupUITests.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 12/12/2022.
//

import XCTest

class SignupUITests: AuthUITestCase<SignupScreenXCUIController> {
	
	override func setUp() {
		// Configure & launch app
		app = XCUIApplication()
		app.launchEnvironment = [.env.context: ENV.Context.test.rawValue]
		app.launch()
		
		navigateToSUT(in: app)
		
		controller = SignupScreenXCUIController(app: app)
		authenticationButtonType = .createAccountButton
	}
	
	func testValidInputs() {
		controller.enter("Abdelrhman", in: .firstNameInput)
		controller.enter("Elmahdy", in: .lastNameInput)
		controller.enter("Abdelrhman@test.com", in: .emailInput)
		controller.enter("Abdelrhman", in: .usernameInput)
		controller.enter("Testtest1", in: .passwordInput)
		controller.enter("Testtest1", in: .confirmPasswordInput)
		
		controller.press(.createAccountButton)
		
		expectAny(of: .noConnectionError, .emailAlreadyInUserError, .successfulAuthentication, timeout: 20)
	}
	
	func testInvalidInputsErrorMessages() {
		// Test empty field validation
		controller.press(.createAccountButton)
		expect(
			.enter(.ui.firstNameTextFieldPlaceholder),
			.enter(.ui.lastNameTextFieldPlaceholder),
			.enter(.ui.email),
			.enter(.ui.username),
			.enter(.ui.password),
			.enter(.ui.confirmPasswordTextFieldNounName)
		)
		
		// Test email validation
		testValidation(in: .emailInput, with: "Abdelrhman.com", andExpect: .invalidEmailError)
		testValidation(in: .emailInput, with: "Abdelrhman@test", andExpect: .invalidEmailError)
		
		// Test weak password validation
		testValidation(in: .passwordInput, with: "1234567", andExpect: .shortPasswordError)
		testValidation(in: .passwordInput, with: "12345678", andExpect: .passwordMissingUpperAndLowerCaseError)
		testValidation(in: .passwordInput, with: "ABCDEFGj", andExpect: .passwordMissingDigitError)
	}
	
	// MARK: Connivence
	
	private func navigateToSUT(in app: XCUIApplication) {
		let loginScreenElementsQuery = app.scrollViews.otherElements
		loginScreenElementsQuery.buttons["Create an account"].tap()
		let didNavigateToSignupScreen = app.contains(.ui.alreadyHaveAccountLabel, waitFor: 5)
		guard didNavigateToSignupScreen else { XCTFail("Did not navigate to signup screen"); return; }
	}
	
}
