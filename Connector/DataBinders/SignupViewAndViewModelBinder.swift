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
		view.firstNameTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$firstName,
			keyPath: \SignupViewModel.firstName,
			for: viewModel,
			storeIn: &subscriptions
		)
		
		view.lastNameTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$lastName,
			keyPath: \SignupViewModel.lastName,
			for: viewModel,
			storeIn: &subscriptions
		)
		
		view.usernameTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$username,
			keyPath: \SignupViewModel.username,
			for: viewModel,
			storeIn: &subscriptions
		)
		
		view.emailTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$email,
			keyPath: \SignupViewModel.email,
			for: viewModel,
			storeIn: &subscriptions
		)
		
		view.passwordTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$password,
			keyPath: \SignupViewModel.password,
			for: viewModel,
			storeIn: &subscriptions
		)
		
		view.confirmPasswordTextFieldView.textField.createBidirectionalBinding(
			with: viewModel.$passwordConfirmation,
			keyPath: \SignupViewModel.passwordConfirmation,
			for: viewModel,
			storeIn: &subscriptions
		)
		
		viewModel.$isUserInteractionEnabled
			.receive(on: DispatchQueue.main)
			.assign(to: \.isUserInteractionEnabled, on: view)
			.store(in: &subscriptions)
		
		viewModel.$isLoading
			.receive(on: DispatchQueue.main)
			.assign(to: \.isLoading, on: view.signupButton)
			.store(in: &subscriptions)
	}
	
}
