//
//  SignupViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine


class SignupViewModel: AuthViewModel {
	let passwordMinimumLengthValidator: Validatable.Validator = { ($0.value.count >= 8, .errors.shortPassword) }
	
	/// Ensures candidate contains at least 1 upper case letter, 1 lower case letter and 1 digit
	let passwordComplexityValidator: Validatable.Validator = { candidate in
		var missingRequirements: [String] = []
		if !candidate.value.includesOneUpperCaseLetter { missingRequirements.append(.errors.oneUpperCaseLetter) }
		if !candidate.value.includesOneLowerCaseLetter { missingRequirements.append(.errors.oneLowerCaseLetter) }
		if !candidate.value.includesOneDigit { missingRequirements.append(.errors.oneDigit) }
		
		let isValid = candidate.value.includesOneUpperCaseLetter
		&& candidate.value.includesOneLowerCaseLetter
		&& candidate.value.includesOneDigit
		
		let errorMessage = isValid ? "" : .errors.passwordMustContainAtLeast(missingRequirements)
		
		return (isValid, errorMessage)
	}
	
	var passwordConfirmationMatchingValidator: Validatable.Validator {
		return { [weak self] candidate in
			return (candidate.value == self?.password, .errors.passwordConfirmationMismatch)
		}
	}
	
	// MARK: State
	
	@Published var firstName: String = ""
	@Published var lastName: String = ""
	@Published var username: String = ""
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var passwordConfirmation: String = ""
	
	// MARK: Business Logic
	
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
