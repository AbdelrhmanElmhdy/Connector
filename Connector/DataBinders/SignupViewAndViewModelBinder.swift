//
//  SignupViewAndViewModelBinder.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine

class SignupViewAndViewModelBinder: ViewAndViewModelBinder<SignupView, SignupViewModel> {
		
	override func setupBindings() {
		// First name
		bind(view.firstNameTextFieldView, with: viewModel.$firstName.$value, keyPath: \SignupViewModel.firstName)
		assign(viewModel.$firstName.$errorMessage, on: view.firstNameTextFieldView)
		// Last name
		bind(view.lastNameTextFieldView, with: viewModel.$lastName.$value, keyPath: \SignupViewModel.lastName)
		assign(viewModel.$lastName.$errorMessage, on: view.lastNameTextFieldView)
		// Email
		bind(view.emailTextFieldView, with: viewModel.$email.$value, keyPath: \SignupViewModel.email)
		assign(viewModel.$email.$errorMessage, on: view.emailTextFieldView)
		// Username
		bind(view.usernameTextFieldView, with: viewModel.$username.$value, keyPath: \SignupViewModel.username)
		assign(viewModel.$username.$errorMessage, on: view.usernameTextFieldView)
		// Password
		bind(view.passwordTextFieldView, with: viewModel.$password.$value, keyPath: \SignupViewModel.password)
		assign(viewModel.$password.$errorMessage, on: view.passwordTextFieldView)
		// Confirm password
		bind(view.confirmPasswordTextFieldView,
				 with: viewModel.$passwordConfirmation.$value,
				 keyPath: \SignupViewModel.passwordConfirmation)
		assign(viewModel.$passwordConfirmation.$errorMessage, on: view.confirmPasswordTextFieldView)
		
		// View State
		
		viewModel.$isLoading
			.receive(on: DispatchQueue.main)
			.map { !$0 }
			.assign(to: \.isUserInteractionEnabled, on: view)
			.store(in: &subscriptions)
		
		viewModel.$isLoading
			.receive(on: DispatchQueue.main)
			.assign(to: \.isLoading, on: view.signupButton)
			.store(in: &subscriptions)
	}
	
	private func bind(_ textFieldView: TextFieldView,
										with publisher: Published<String>.Publisher,
										keyPath: ReferenceWritableKeyPath<SignupViewModel, String>) {
		textFieldView.textField.createBidirectionalBinding(
			with: publisher,
			keyPath: keyPath,
			for: viewModel,
			storeIn: &subscriptions
		)
	}
	
	private func assign(_ publisher: Published<String>.Publisher, on textFieldView: TextFieldView) {
		publisher
			.receive(on: DispatchQueue.main)
			.assign(to: \.errorMessage, on: textFieldView)
			.store(in: &subscriptions)
	}
	
}
