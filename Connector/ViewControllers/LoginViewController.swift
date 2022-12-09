//
//  LoginViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    private let controlledView: AuthView
    private let viewModel: AuthViewModel
    private unowned let coordinator: Authenticating & CreatingAccount
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Initialization
    
    init(coordinator: Authenticating & CreatingAccount, viewModel: AuthViewModel, view: LoginView) {
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
        
        guard let controlledView = controlledView as? LoginView else { return }
        
        controlledView.loginButton.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
        controlledView.createAccountButton.addTarget(self, action: #selector(didPressCreateAccount), for: .touchUpInside)
        
        configureTextFieldsForKeyboardTraversal(controlledView.textFields)
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
    
    func setupBindings() {
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
    }
    
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
        ErrorManager.shared.presentError(errorMessage: error.localizedDescription, originalError: error, reportError: true)
    }
}
