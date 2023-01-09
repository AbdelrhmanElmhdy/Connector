//
//  AuthViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/10/2022.
//

import UIKit
import Combine

class AuthViewModel {
	// MARK: Business Logic Constants
	
	static let emptyInputValidator: Validatable.Validator = {
		(!($0.value as! String).isEmpty, .errors.enter($0.nounName))
	}
	
	static let emailValidator: Validatable.Validator = { (($0.value as! String).isEmail, .errors.invalidEmail) }
	
	// MARK: State
	
	@Published var isLoading: Bool = false
	var allInputsAreValid: Bool = false
	
	// MARK: Services
	
	// Services are declared as internal properties to be accessible by subclasses.
	let authService: AuthService
	let userService: UserService
	
	// MARK: Initialization
	
	init(authService: AuthService, userService: UserService) {
		self.authService = authService
		self.userService = userService
	}
	
	// MARK: Business Logic
	
	/// Validate each input against its validators and return the invalid inputs along with their respective error messages.
	/// - Parameter inputs: Validatable objects that contain validators to be checked against.
	func validateInputs(_ inputs: any Validatable...){
		var allInputsAreValid = true
		
		for input in inputs {
			let (isValid, errorMessage) = input.validate(using: input.validators)
			if !isValid {
				input.errorMessage = errorMessage ?? ""
				allInputsAreValid = false
			}
		}
		
		self.allInputsAreValid = allInputsAreValid
	}
	
}
