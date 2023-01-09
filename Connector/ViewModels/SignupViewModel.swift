//
//  SignupViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine



class SignupViewModel: AuthViewModel {
	private typealias VM = SignupViewModel
	
	static let minimumLengthValidator: (_ length: Int) -> Validatable.Validator = { length in
		{ candidate in
			((candidate.value as! String).count >= length, candidate.nounName + " " + .errors.mustBeAtLeast(ofLength: length))
		}
	}
	
	/// Ensures candidate contains at least 1 upper case letter, 1 lower case letter and 1 digit
	static let passwordComplexityValidator: Validatable.Validator = { candidate in
		let value = candidate.value as! String
		
		var missingRequirements: [String] = []
		if !value.includesOneUpperCaseLetter { missingRequirements.append(.errors.oneUpperCaseLetter) }
		if !value.includesOneLowerCaseLetter { missingRequirements.append(.errors.oneLowerCaseLetter) }
		if !value.includesOneDigit { missingRequirements.append(.errors.oneDigit) }
		
		let isValid = value.includesOneUpperCaseLetter && value.includesOneLowerCaseLetter && value.includesOneDigit
		
		let errorMessage = isValid ? "" : .errors.passwordMustContainAtLeast(missingRequirements)
		
		return (isValid, errorMessage)
	}
	
	var passwordConfirmationMatchingValidator: Validatable.Validator {
		return { [weak self] candidate in
			return ((candidate.value as? String) == self?.password, .errors.passwordConfirmationMismatch)
		}
	}
	
	// MARK: State
	
	@PublishedValidatable(nounName: .ui.firstNameTextFieldPlaceholder, validators: [VM.emptyInputValidator])
	var firstName: String = ""
	
	@PublishedValidatable(nounName: .ui.lastNameTextFieldPlaceholder, validators: [VM.emptyInputValidator])
	var lastName: String = ""
	
	@PublishedValidatable(nounName: .ui.username, validators: [VM.emptyInputValidator])
	var username: String = ""
	
	@PublishedValidatable(nounName: .ui.email, validators: [VM.emptyInputValidator, VM.emailValidator])
	var email: String = ""
	
	@PublishedValidatable(nounName: .ui.password, validators: [
		VM.emptyInputValidator,
		VM.minimumLengthValidator(8),
		VM.passwordComplexityValidator
	])
	var password: String = ""
	
	@PublishedValidatable(nounName: .ui.confirmPasswordTextFieldNounName, validators: [VM.emptyInputValidator])
	var passwordConfirmation: String = ""
	
	override init(authService: AuthService, userService: UserService) {
		super.init(authService: authService, userService: userService)
		$passwordConfirmation.validators.append(passwordConfirmationMatchingValidator)
	}
	
	// MARK: Business Logic
	
	func validateInputs() {
		validateInputs($firstName, $lastName, $email, $username, $password, $passwordConfirmation)
	}
	
	func createUser(firstName: String, lastName: String, username: String, email: String) -> User {
		let user = userService.createUser()
		
		user.id = ""
		user.firstName = firstName
		user.lastName = lastName
		user.username = username.lowercased()
		user.email = email
		
		return user
	}
	
	func signup(user: User, password: String) -> Future <Void, Error> {
		return authService.signup(user: user, password: password)
	}
}
