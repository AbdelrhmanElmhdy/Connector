//
//  LoginViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit
import Combine

class LoginViewController: AuthViewController {
    // MARK: Properties
    
    unowned var coordinator: Authenticating & CreatingAccount
    
    // MARK: Initialization
    
    init(coordinator: Authenticating & CreatingAccount, viewModel: AuthViewModel) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove the password field complexity validator.
        passwordTextFieldView.validators = [viewModel.nonEmptyFieldValidator]
        
        // Configure labels and button titles
        authenticationBtn.setTitle("Login".localized, for: .normal)
        otherAuthMethodLabel.text = "Not an existing user?".localized
        otherAuthMethodBtn.setTitle("Create an account".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Actions
    
    override func didPressAuthenticationButton() {
        // Validate all inputs.
        let (invalidInputs, errorMessages) = viewModel.validateInputs(emailTextFieldView, passwordTextFieldView)
        
        for (index, input) in invalidInputs.enumerated() {
            let errorMessage = errorMessages[index]
            input.presentErrorMessage(errorMessage)
        }
        
        let allInputsAreValid = invalidInputs.isEmpty
        guard allInputsAreValid else { return }
        
        // Disable user interactions and show spinner.
        view.isUserInteractionEnabled = false
        authenticationBtn.isLoading = true
        
        // Commence login procedure.
        viewModel.login(email: viewModel.email, password: viewModel.password)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: handleUserLoginCompletion, receiveValue: {})
            .store(in: &subscriptions)
    }
    
    override func didPressOtherAuthMethodButton() {
        coordinator.createNewAccount()
    }
    
    // MARK: Convenience
        
    func handleUserLoginCompletion(completion: Subscribers.Completion<Error>) {
       self.view.isUserInteractionEnabled = true
       self.authenticationBtn.isLoading = false
       
        switch completion {
        case .failure(let error):
            handleLoginFailure(error: error)
        case .finished:
            coordinator.didFinishAuthentication()
        }
    }
    
    func handleLoginFailure(error: Error) {
        ErrorManager.shared.presentError(errorMessage: "Incorrect email or password".localized, originalError: error, reportError: true)
    }
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        let arrangedSubviews = [emailTextFieldView, passwordTextFieldView]
        return arrangedSubviews
    }
    
}
