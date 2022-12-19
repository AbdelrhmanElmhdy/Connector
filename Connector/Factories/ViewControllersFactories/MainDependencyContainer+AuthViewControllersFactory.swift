//
//  MainDependencyContainer+AuthViewControllersFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

extension MainDependencyContainer: AuthViewControllersFactory {
    func createLoginViewController(for coordinator: Authenticating & CreatingAccount) -> LoginViewController {
        let viewModel = LoginViewModel(authService: authService, userService: userService)
        let view = LoginView(viewModel: viewModel)
        let dataBinder = LoginViewAndViewModelBinder(view: view, viewModel: viewModel)
        
        let viewController = LoginViewController(
            coordinator: coordinator, view: view, viewModel: viewModel, dataBinder: dataBinder
        )
        return viewController
    }
    
    func createSignupViewController(for coordinator: Authenticating & LoggingIn) -> SignupViewController {
        let viewModel = SignupViewModel(authService: authService, userService: userService)
        let view = SignupView(viewModel: viewModel)
        let dataBinder = SignupViewAndViewModelBinder(view: view, viewModel: viewModel)
        
        let viewController = SignupViewController(
            coordinator: coordinator, view: view, viewModel: viewModel, dataBinder: dataBinder
        )
        return viewController
    }
}
