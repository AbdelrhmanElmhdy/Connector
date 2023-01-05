//
//  AuthCoordinatorMock.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/12/2022.
//

import UIKit

class AuthCoordinatorMock: Coordinator, LoggingIn, CreatingAccount, Authenticating {
	var children = Array<Coordinator>()
	let navigationController: UINavigationController = UINavigationController()
	
	
	func start() {
		
	}
	
	func loginWithExistingAccount() {
		
	}
	
	func createNewAccount() {
		
	}
	
	func didFinishAuthentication() {
		
	}
	
}
