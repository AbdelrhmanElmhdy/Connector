//
//  LoginViewAndViewModelBinder.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine

class LoginViewAndViewModelBinder: ViewAndViewModelBinder<LoginView, LoginViewModel> {
	
	override func setupBindings() {
		// email
		
		view.emailTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$email.$value,
			keyPath: \LoginViewModel.email,
			for: viewModel,
			storeIn: &subscriptions
		)
		
		viewModel.$email.$errorMessage
			.receive(on: DispatchQueue.main)
			.assign(to: \.errorMessage, on: view.emailTextFieldView)
			.store(in: &subscriptions)
		
		// Password
		
		view.passwordTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$password.$value,
			keyPath: \LoginViewModel.password,
			for: viewModel,
			storeIn: &subscriptions
		)
				
		viewModel.$password.$errorMessage
			.receive(on: DispatchQueue.main)
			.assign(to: \.errorMessage, on: view.passwordTextFieldView)
			.store(in: &subscriptions)
		
		// View state
		
		viewModel.$isLoading
			.receive(on: DispatchQueue.main)
			.map { !$0 }
			.assign(to: \.isUserInteractionEnabled, on: view)
			.store(in: &subscriptions)
		
		viewModel.$isLoading
			.receive(on: DispatchQueue.main)
			.assign(to: \.isLoading, on: view.loginButton)
			.store(in: &subscriptions)
	}
	
}
