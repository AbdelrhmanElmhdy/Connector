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
    
    private let controlledView: AuthView
    private let viewModel: AuthViewModel
    private unowned let coordinator: Authenticating & LoggingIn
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Initialization
    
    init(coordinator: Authenticating & LoggingIn, viewModel: AuthViewModel, view: SignupView) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.controlledView = view
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
        
        guard let controlledView = controlledView as? SignupView else { return }
        
        controlledView.signupButton.addTarget(self, action: #selector(didPressSignup), for: .touchUpInside)
        controlledView.loginButton.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
        
        configureTextFieldsForKeyboardTraversal(controlledView.textFields)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Event Handlers
    
    @objc func didPressSignup() {
        // Validate all fields.
        let (invalidInputs, errorMessages) = viewModel.validateInputs(controlledView.firstNameTextFieldView,
                                                                      controlledView.lastNameTextFieldView,
                                                                      controlledView.usernameTextFieldView,
                                                                      controlledView.emailTextFieldView,
                                                                      controlledView.passwordTextFieldView,
                                                                      controlledView.confirmPasswordTextFieldView)
        
        // Check if all fields are valid and present error messages for the invalid ones.
        let allInputsAreValid = invalidInputs.isEmpty
        if (!allInputsAreValid) {
            presentErrorMessagesForInvalidInputs(invalidInputs: invalidInputs, errorMessages: errorMessages)
        }
        
        // Check that password confirmation matches password and present error message if it doesn't.
        let passwordsMatch = viewModel.passwordConfirmation == viewModel.password
        if !passwordsMatch {
            presentPasswordsDoNotMatchErrorMessage()
        }
        
        guard allInputsAreValid && passwordsMatch else { return }
        
        disableUserInteractionsAndShowSpinner()
        
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
    
    @objc func didPressLogin() {
        coordinator.loginWithExistingAccount()
    }
    
    // MARK: Convenience
    
    func setupBindings() {
        controlledView.firstNameTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$firstName,
            keyPath: \AuthViewModel.firstName,
            for: viewModel,
            storeIn: &subscriptions
        )
        
        controlledView.lastNameTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$lastName,
            keyPath: \AuthViewModel.lastName,
            for: viewModel,
            storeIn: &subscriptions
        )
        
        controlledView.usernameTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$username,
            keyPath: \AuthViewModel.username,
            for: viewModel,
            storeIn: &subscriptions
        )
                
        controlledView.emailTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$email,
            keyPath: \AuthViewModel.email,
            for: viewModel,
            storeIn: &subscriptions
        )
        
        controlledView.passwordTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$password,
            keyPath: \AuthViewModel.password,
            for: viewModel,
            storeIn: &subscriptions
        )
        
        controlledView.confirmPasswordTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$passwordConfirmation,
            keyPath: \AuthViewModel.passwordConfirmation,
            for: viewModel,
            storeIn: &subscriptions
        )
    }
    
    func presentErrorMessagesForInvalidInputs(invalidInputs: [Validatable], errorMessages: [String]) {
        for (index, input) in invalidInputs.enumerated() {
            let errorMessage = errorMessages[index]
            input.presentErrorMessage(errorMessage)
        }
    }
        
    func presentPasswordsDoNotMatchErrorMessage() {
        controlledView.confirmPasswordTextFieldView.presentErrorMessage("Passwords don't match".localized)
    }
    
    func disableUserInteractionsAndShowSpinner() {
        controlledView.isUserInteractionEnabled = false
        controlledView.authenticationBtn.isLoading = true
    }
        
    func handleUserSignupCompletion(completion: Subscribers.Completion<Error>) {
        controlledView.isUserInteractionEnabled = true
        controlledView.authenticationBtn.isLoading = false

        switch completion {
        case .failure(let error):
            handleSignupFailure(error: error)
        case .finished:
            coordinator.didFinishAuthentication()
        }
    }
    
    func handleSignupFailure(error: Error) {
        ErrorManager.shared.reportError(error)
        let alertPopup = AlertPopup()
        alertPopup.presentAsError(withMessage: error.localizedDescription)
    }
    
}
