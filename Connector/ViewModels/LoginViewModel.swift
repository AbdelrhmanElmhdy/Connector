//
//  LoginViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine

fileprivate typealias VM = LoginViewModel

class LoginViewModel: AuthViewModel {
	// MARK: State
	
	@PublishedValidatable(nounName: .ui.email, validators: [VM.emptyInputValidator, VM.emailValidator])
	var email: String = ""
	
	@PublishedValidatable(nounName: .ui.password, validators: [VM.emptyInputValidator])
	var password: String = ""
	
	// MARK: Business Logic
	
	func validateInputs() {
		validateInputs($email, $password)
	}
	
	func login(email: String, password: String) -> Future <Void, Error> {
		return authService.login(email: email, password: password)
	}
		
}
