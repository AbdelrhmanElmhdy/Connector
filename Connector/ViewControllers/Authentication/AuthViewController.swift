//
//  AuthenticationViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit
import Combine

class AuthViewController: UIViewController {
    
    // MARK: Properties
    
    let controlledView: AuthView
    let viewModel: AuthViewModel
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: Initialization
    
    init(view: AuthView, viewModel: AuthViewModel) {
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
        
        configureTextFields(inStackView: controlledView.textFieldsStackView)
        setupBindings()
        
        view.backgroundColor = .systemBackground
    }
    
    // MARK: Convenience
        
    func configureTextFields(inStackView stackView: UIStackView) {
        for (index, arrangedSubview) in stackView.arrangedSubviews.enumerated() {
            guard let textFieldView = arrangedSubview as? TextFieldView else { return }
            textFieldView.textField.delegate = self
            textFieldView.textField.tag = index
            
            let isLastTextField = index == stackView.arrangedSubviews.count - 1
            textFieldView.textField.returnKeyType = isLastTextField ? .continue :  .next
        }
    }
    
    func setupBindings() {
        controlledView.firstNameTextFieldView.textField.createBidirectionalBinding(with: viewModel.$firstName,
                                                                    keyPath: \AuthViewModel.firstName,
                                                                    for: viewModel,
                                                                    storeIn: &subscriptions)
        
        controlledView.lastNameTextFieldView.textField.createBidirectionalBinding(with: viewModel.$lastName,
                                                                   keyPath: \AuthViewModel.lastName,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
        
        controlledView.usernameTextFieldView.textField.createBidirectionalBinding(with: viewModel.$username,
                                                                   keyPath: \AuthViewModel.username,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
                
        controlledView.emailTextFieldView.textField.createBidirectionalBinding(with: viewModel.$email,
                                                                keyPath: \AuthViewModel.email,
                                                                for: viewModel,
                                                                storeIn: &subscriptions)
        
        controlledView.passwordTextFieldView.textField.createBidirectionalBinding(with: viewModel.$password,
                                                                   keyPath: \AuthViewModel.password,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
        
        controlledView.confirmPasswordTextFieldView.textField.createBidirectionalBinding(with: viewModel.$passwordConfirmation,
                                                                   keyPath: \AuthViewModel.passwordConfirmation,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focusOnNextTextFieldOnPressReturn(from: textField)
        return false
    }
    
}
