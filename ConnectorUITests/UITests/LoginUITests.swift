//
//  LoginUITests.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 03/01/2023.
//

import XCTest

class LoginUITests: AuthUITestCase<LoginScreenXCUIController> {
	
	override func setUp() {
		// Configure & launch app
		app = XCUIApplication()
		app.launchEnvironment = [.env.context: ENV.Context.test.rawValue]
		app.launch()

		controller = LoginScreenXCUIController(app: app)
		authenticationButtonType = .loginButton
	}
	
	func testValidInputs() {
		controller.enter("Abdelrhman@test.com", in: .emailInput)
		controller.enter("Testtest1", in: .passwordInput)
		
		controller.press(.loginButton)
		
		expectAny(of: .noConnectionError, .userNotFoundError, .successfulAuthentication, timeout: 20)
	}
	
	func testInvalidInputsErrorMessages() {
		// Test empty field validation
		controller.press(.loginButton)
		expect(.enter(.ui.email), .enter(.ui.password))
		
		// Test email validation
		testValidation(in: .emailInput, with: "Abdelrhman.com", andExpect: .invalidEmailError)
		testValidation(in: .emailInput, with: "Abdelrhman@test", andExpect: .invalidEmailError)
	}
	
}
