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
    
    init(coordinator: Authenticating & CreatingAccount, viewModel: AuthViewModel, view: LoginView) {
        self.coordinator = coordinator
        super.init(view: view, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let controlledView = controlledView as? LoginView else { return }
        
        controlledView.loginButton.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
        controlledView.createAccountButton.addTarget(self, action: #selector(didPressCreateAccount), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Actions
    
    @objc func didPressLogin() {
        // Validate all inputs.
        let (invalidInputs, errorMessages) = viewModel.validateInputs(controlledView.emailTextFieldView,
                                                                      controlledView.passwordTextFieldView)
        
        for (index, input) in invalidInputs.enumerated() {
            let errorMessage = errorMessages[index]
            input.presentErrorMessage(errorMessage)
        }
        
        let allInputsAreValid = invalidInputs.isEmpty
        guard allInputsAreValid else { return }
        
        // Disable user interactions and show spinner.
        controlledView.isUserInteractionEnabled = false
        controlledView.authenticationBtn.isLoading = true
        
        // Commence login procedure.
        viewModel.login(email: viewModel.email, password: viewModel.password)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: handleUserLoginCompletion, receiveValue: {})
            .store(in: &subscriptions)
    }
    
    @objc func didPressCreateAccount() {
        coordinator.createNewAccount()
    }
    
    // MARK: Convenience
        
    func handleUserLoginCompletion(completion: Subscribers.Completion<Error>) {
        controlledView.isUserInteractionEnabled = true
        controlledView.authenticationBtn.isLoading = false
       
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
}
