//
//  SignupViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit
import CoreData
import Combine

class SignupViewController: AuthViewController {
    // MARK: Properties
    
    unowned var coordinator: Authenticating & LoggingIn
    
    // MARK: Initialization
    
    init(coordinator: Authenticating & LoggingIn, viewModel: AuthViewModel, view: SignupView) {
        self.coordinator = coordinator
        super.init(view: view, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let controlledView = controlledView as? SignupView else { return }
        
        controlledView.signupButton.addTarget(self, action: #selector(didPressSignup), for: .touchUpInside)
        controlledView.loginButton.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
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
