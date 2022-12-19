//
//  LoginViewAndViewModelBinder.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine

class LoginViewAndViewModelBinder: ViewAndViewModelBinder<LoginView, LoginViewModel> {
    
    override func setupBindings() {
        view.emailTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$email,
            keyPath: \LoginViewModel.email,
            for: viewModel,
            storeIn: &subscriptions
        )
        
        view.passwordTextFieldView.textField.createBidirectionalBinding(
            with: viewModel.$password,
            keyPath: \LoginViewModel.password,
            for: viewModel,
            storeIn: &subscriptions
        )
        
        viewModel.$isUserInteractionEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isUserInteractionEnabled, on: view)
            .store(in: &subscriptions)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: view.loginButton)
            .store(in: &subscriptions)
    }
    
}
