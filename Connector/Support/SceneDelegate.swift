//
//  SceneDelegate.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/06/2022.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let dependencyContainer = (UIApplication.shared.delegate as! AppDelegate).dependencyContainer
        
        coordinator = MainCoordinator(navigationController: navigationController,
                                      viewControllerFactory: dependencyContainer,
                                      authServices: dependencyContainer.authServices)
        coordinator?.start()
    }

}

