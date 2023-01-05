//
//  LoginViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit
import Combine
import SwiftUI

class LoginViewController: UIViewController {
	
	// MARK: Properties
	
	private let controlledView: LoginView
	private let viewModel: LoginViewModel
	private let dataBinder: ViewAndViewModelBinder<LoginView, LoginViewModel>
	private unowned let coordinator: Authenticating & CreatingAccount
	
	private var subscriptions = Set<AnyCancellable>()
	
	// MARK: Initialization
	
	init(coordinator: Authenticating & CreatingAccount,
			 view: LoginView,
			 viewModel: LoginViewModel,
			 dataBinder: ViewAndViewModelBinder<LoginView, LoginViewModel>) {
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
		
		controlledView.loginButton.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
		controlledView.createAccountButton.addTarget(self, action: #selector(didPressCreateAccount), for: .touchUpInside)
		
		configureTextFieldsForKeyboardTraversal(controlledView.textFields)
		dataBinder.setupBindings()
		hideKeyboardWhenTappedAround()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	// MARK: Actions
	
	@objc private func didPressLogin() {
		dismissKeyboard()
		
		// Validate all inputs.
		let invalidInputsErrorMessages = viewModel.validateInputs(controlledView.emailTextFieldView,
																															controlledView.passwordTextFieldView)
		
		viewModel.presentErrorMessagesForInvalidInputs(invalidInputsErrorMessages: invalidInputsErrorMessages)
		
		let allInputsAreValid = invalidInputsErrorMessages.isEmpty
		guard allInputsAreValid else { return }
		
		viewModel.disableUserInteraction(); /* & */ viewModel.showLoadingSpinner();
		
		// Commence login procedure.
		viewModel.login(email: viewModel.email, password: viewModel.password)
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: handleUserLoginCompletion, receiveValue: {})
			.store(in: &subscriptions)
	}
	
	@objc private func didPressCreateAccount() {
		dismissKeyboard()
		coordinator.createNewAccount()
	}
	
	// MARK: Completion Handlers
	
	private func handleUserLoginCompletion(completion: Subscribers.Completion<Error>) {
		viewModel.enableUserInteraction(); /* & */ viewModel.hideLoadingSpinner();
		
		switch completion {
		case .failure(let error):
			handleLoginFailure(error: error)
		case .finished:
			coordinator.didFinishAuthentication()
		}
	}
	
	private func handleLoginFailure(error: Error) {
		let reportError = (error as? FirebaseAuthError)?.isFatal ?? true // Only report a FirebaseAuthError if it's marked fatal.
		ErrorManager.shared.presentError(error, reportError: reportError)
	}
}

// MARK: Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct LoginViewController_Preview: PreviewProvider {
	static var previews: some View {
		ForEach(deviceNames, id: \.self) { deviceName in
			UIViewControllerPreview {
				AppDelegate.shared.viewControllerFactory.createLoginViewController(for: AuthCoordinatorMock())
			}.previewDevice(PreviewDevice(rawValue: deviceName))
				.previewDisplayName(deviceName)
		}
	}
}
#endif
