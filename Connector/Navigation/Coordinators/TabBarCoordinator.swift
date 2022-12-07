//
//  TabBarCoordinator.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import UIKit

class TabBarCoordinator: Coordinator {
    var children = Array<Coordinator>()
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllerFactory
    unowned var parentCoordinator: MainCoordinator
    var rootTabBarController: RootTabBarController!
    
    init(navigationController: UINavigationController,
         viewControllerFactory: ViewControllerFactory,
         parentCoordinator: MainCoordinator
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.parentCoordinator = parentCoordinator
        self.rootTabBarController = RootTabBarController(coordinator: self)
    }
    
    func start() {
        let (chatsNavigationController, callsNavigationController, settingsNavigationController) = createNavControllersForTabs()
                
        rootTabBarController.viewControllers = [
            chatsNavigationController,
            callsNavigationController,
            settingsNavigationController
        ]
        
        let chatsCoordinator = ChatsCoordinator(navigationController: chatsNavigationController,
                                                viewControllerFactory: viewControllerFactory,
                                                parentCoordinator: self)
        
        let callsCoordinator = CallsCoordinator(navigationController: callsNavigationController,
                                                viewControllerFactory: viewControllerFactory,
                                                parentCoordinator: self)
        
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNavigationController,
                                                      viewControllerFactory: viewControllerFactory,
                                                      parentCoordinator: self)
        
        startChild(chatsCoordinator)
        startChild(callsCoordinator)
        startChild(settingsCoordinator)
        
        navigationController.pushViewController(rootTabBarController, animated: false)
    }
    
    /// Instantiate and customize a navigation controller for each tab.
    private func createNavControllersForTabs() -> (
        chatsNavigationController: UINavigationController,
        callsNavigationController: UINavigationController,
        settingsNavigationController: UINavigationController
    ) {
        let chatsNavigationController = UINavigationController()
        chatsNavigationController.tabBarItem = UITabBarItem(
            title: "Chats".localized,
            image: UIImage(systemName: "message.fill"),
            tag: 0
        )
        
        let callsNavigationController = UINavigationController()
        callsNavigationController.tabBarItem = UITabBarItem(
            title: "Calls".localized,
            image: UIImage(systemName: "phone.fill"),
            tag: 1
        )
        
        let settingsNavigationController = UINavigationController()
        settingsNavigationController.tabBarItem = UITabBarItem(
            title: "Settings".localized,
            image: UIImage(systemName: "gear"),
            tag: 2
        )
        
        return (chatsNavigationController, callsNavigationController, settingsNavigationController)
    }
    
    func logout() {
        parentCoordinator.childDidFinish(self)
    }
}
