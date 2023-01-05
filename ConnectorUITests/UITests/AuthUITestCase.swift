//
//  AuthUITestCase.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 03/01/2023.
//

import XCTest

class AuthUITestCase<Controller: XCUITextInputController>: XCTestCase, ExpectsOutcomes {
	enum ExpectedOutcome: Outcome {
		case enter(_ missingValue: String)
		case invalidEmailError
		case shortPasswordError
		case passwordMissingUpperAndLowerCaseError
		case passwordMissingDigitError
		case noConnectionError
		case emailAlreadyInUserError
		case userNotFoundError
		case successfulAuthentication
		
		func didOccur(in container: XCUIElement) -> Bool {
			switch self {
			case let .enter(missingValue): return container.contains(.errors.enter(missingValue))
			case .invalidEmailError: return container.contains(.errors.invalidEmail)
			case .shortPasswordError: return container.contains(.errors.shortPassword)

			case .passwordMissingUpperAndLowerCaseError:
				return container.contains(.errors.passwordMustContainAtLeast([.errors.oneUpperCaseLetter, .errors.oneLowerCaseLetter]))

			case .passwordMissingDigitError: return container.contains(.errors.passwordMustContainAtLeast([.errors.oneDigit]))
			case .noConnectionError: return container.contains(.errors.networkError.userDescription)
			case .emailAlreadyInUserError: return container.contains(.errors.emailAlreadyInUseError.userDescription)
			case .userNotFoundError: return container.contains(.errors.userNotFoundError.userDescription)
			case .successfulAuthentication: return container.contains(.ui.chats)
			}
		}
	}
	
	var app: XCUIApplication!
	var controller: Controller!
	var authenticationButtonType: Controller.ButtonType!
	
	func testValidation(in inputType: Controller.InputType, with text: String, andExpect expectedOutcome: ExpectedOutcome) {
		controller.enter(text, in: inputType)
		controller.dismissKeyboard()
		controller.press(authenticationButtonType)
		expect(expectedOutcome)
	}
	
}

