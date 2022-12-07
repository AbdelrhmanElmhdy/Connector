//
//  MainCoordinator.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 22/11/2022.
//

import UIKit

class MainCoordinator: Coordinator {
    var children = Array<Coordinator>()
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllerFactory
    var authServices: AuthServicesProtocol
    lazy var rootTabBarController = RootTabBarController(coordinator: self)
    
    init(navigationController: UINavigationController,
         viewControllerFactory: ViewControllerFactory,
         authServices: AuthServicesProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.authServices = authServices
        
        self.navigationController.view.backgroundColor = .systemBackground
    }
    
    func start() {
        if authServices.isLoggedIn {
            startTabBar()
        } else {
            startAuthentication()
        }
    }
    
    private func startAuthentication(animated: Bool = false) {
        let authenticationNavigationController = UINavigationController()
        let authenticationCoordinator = AuthCoordinator(
            navigationController: authenticationNavigationController,
            viewControllerFactory: viewControllerFactory,
            parentCoordinator: self
        )
        
        startChild(authenticationCoordinator)
        authenticationNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(authenticationNavigationController, animated: animated)
    }
    
    private func startTabBar(animated: Bool = false) {
        let tabBarNavigationController = UINavigationController()
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: tabBarNavigationController,
            viewControllerFactory: viewControllerFactory,
            parentCoordinator: self
        )
        
        startChild(tabBarCoordinator)
        tabBarNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(tabBarNavigationController, animated: animated)
    }
                
    func childDidFinish(_ finishedChild: Coordinator) {
        finishedChild.dismiss(animated: true)
        removeChild(finishedChild)
        
        if finishedChild is AuthCoordinator { // User has completed authentication.
            startTabBar(animated: true)
        } else if finishedChild is TabBarCoordinator { // User has logged out.
            startAuthentication(animated: true)
        }
    }
    
}
