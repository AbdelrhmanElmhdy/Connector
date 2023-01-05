//
//  SignupViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit
import CoreData
import Combine

class SignupViewController: UIViewController {
	// MARK: Properties
	
	private let controlledView: SignupView
	private let viewModel: SignupViewModel
	private let dataBinder: ViewAndViewModelBinder<SignupView, SignupViewModel>
	private unowned let coordinator: Authenticating & LoggingIn
	
	private var subscriptions = Set<AnyCancellable>()
	
	// MARK: Initialization
	
	init(coordinator: Authenticating & LoggingIn,
			 view: SignupView,
			 viewModel: SignupViewModel,
			 dataBinder: ViewAndViewModelBinder<SignupView, SignupViewModel>) {
		self.coordinator = coordinator
		self.viewModel = viewModel
		self.controlledView = view
		self.dataBinder = dataBinder
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Life Cycle
	
	override func loadView() {
		view = controlledView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		controlledView.signupButton.addTarget(self, action: #selector(didPressSignup), for: .touchUpInside)
		controlledView.loginButton.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
		
		configureTextFieldsForKeyboardTraversal(controlledView.textFields)
		dataBinder.setupBindings()
		hideKeyboardWhenTappedAround()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	// MARK: Event Handlers
	
	@objc private func didPressSignup() {
		dismissKeyboard()
		
		// Validate all fields.
		let invalidInputsErrorMessages = viewModel.validateInputs(controlledView.firstNameTextFieldView,
																															controlledView.lastNameTextFieldView,
																															controlledView.usernameTextFieldView,
																															controlledView.emailTextFieldView,
																															controlledView.passwordTextFieldView,
																															controlledView.confirmPasswordTextFieldView)
		
		viewModel.presentErrorMessagesForInvalidInputs(invalidInputsErrorMessages: invalidInputsErrorMessages)
		
		let allInputsAreValid = invalidInputsErrorMessages.isEmpty
		guard allInputsAreValid else { return }
		
		viewModel.disableUserInteraction(); /* & */ viewModel.showLoadingSpinner();
		
		// Create user.
		let user = viewModel.createUser(firstName: viewModel.firstName,
																		lastName: viewModel.lastName,
																		username: viewModel.username,
																		email: viewModel.email)
		
		// (3... 2... 1...) Commence signup procedure.
		viewModel.signup(user: user, password: viewModel.password)
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: handleUserSignupCompletion, receiveValue: {})
			.store(in: &subscriptions)
	}
	
	@objc private func didPressLogin() {
		dismissKeyboard()
		coordinator.loginWithExistingAccount()
	}
	
	// MARK: Completion Handlers
	
	private func handleUserSignupCompletion(completion: Subscribers.Completion<Error>) {
		viewModel.enableUserInteraction(); /* & */ viewModel.hideLoadingSpinner();
		
		switch completion {
		case .failure(let error):
			handleSignupFailure(error: error)
		case .finished:
			coordinator.didFinishAuthentication()
		}
	}
	
	private func handleSignupFailure(error: Error) {
		let reportError = (error as? FirebaseAuthError)?.isFatal ?? true // Only report a FirebaseAuthError if it's marked fatal.
		ErrorManager.shared.presentError(error, reportError: reportError)
	}
	
}

// MARK: Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SignupViewController_Preview: PreviewProvider {
	static var previews: some View {
		ForEach(deviceNames, id: \.self) { deviceName in
			UIViewControllerPreview {
				AppDelegate.shared.viewControllerFactory.createSignupViewController(for: AuthCoordinatorMock())
			}.previewDevice(PreviewDevice(rawValue: deviceName))
				.previewDisplayName(deviceName)
		}
	}
}
#endif
