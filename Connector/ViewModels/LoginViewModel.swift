//
//  LoginViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine

class LoginViewModel: AuthViewModel {
	// MARK: State
	
	@Published var email: String = ""
	@Published var password: String = ""
	
	func login(email: String, password: String) -> Future <Void, Error> {
		return authService.login(email: email, password: password)
	}
}
