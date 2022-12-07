//
//  AuthCoordinator.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/11/2022.
//

import UIKit

class AuthCoordinator: Coordinator, LoggingIn, CreatingAccount, Authenticating {
    var children = Array<Coordinator>()
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllerFactory
    unowned var parentCoordinator: MainCoordinator
    
    init(navigationController: UINavigationController,
         viewControllerFactory: ViewControllerFactory,
         parentCoordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let loginViewController = viewControllerFactory.createLoginViewController(for: self)
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func loginWithExistingAccount() {
        if navigationController.previousViewController is LoginViewController {
            navigationController.popViewController(animated: true)
            return
        }
        
        let loginViewController = viewControllerFactory.createLoginViewController(for: self)
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func createNewAccount() {
        if navigationController.previousViewController is SignupViewController {
            navigationController.popViewController(animated: true)
            return
        }
        
        let signupViewController = viewControllerFactory.createSignupViewController(for: self)
        navigationController.pushViewController(signupViewController, animated: true)
    }
    
    func didFinishAuthentication() {
        navigationController.dismiss(animated: true)
        parentCoordinator.childDidFinish(self)
    }
    
}
