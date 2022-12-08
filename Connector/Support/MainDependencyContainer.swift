//
//  MainDependencyContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import UIKit

class MainDependencyContainer: DependencyContainer {
    // MARK: Managers
    
    lazy var userDefaultsManager = UserDefaultsManager()
    lazy var keychainManager = KeychainManager()
    lazy var coreDataManager = CoreDataManager(persistentContainerName: "Connector")
    lazy var firebaseManager = FirebaseManager()
    
    // MARK: Services
    
    lazy var authNetworkServices: AuthNetworkServicesProtocol = AuthNetworkServices(firebaseManager: firebaseManager)
    
    lazy var authServices: AuthServicesProtocol = AuthServices(userDefaultsManager: userDefaultsManager,
                                                               keychainManager: keychainManager,
                                                               coreDataManager: coreDataManager,
                                                               authNetworkServices: authNetworkServices)
    
    lazy var userNetworkServices: UserNetworkServicesProtocol = UserNetworkServices(firebaseManager: firebaseManager)
    
    lazy var userServices: UserServicesProtocol = UserServices(
        coreDataManager: coreDataManager,
        userNetworkServices: userNetworkServices,
        authServices: authServices
    )
        
    lazy var chatRoomServices: ChatRoomServicesProtocol = ChatRoomServices(coreDataManager: coreDataManager)
    
    lazy var chatMessageNetworkServices: ChatMessageNetworkServicesProtocol = ChatMessageNetworkServices(
        firebaseManager: firebaseManager
    )
    
    lazy var chatMessageServices: ChatMessageServicesProtocol = ChatMessageServices(
        coreDataManager: coreDataManager,
        chatMessageNetworkServices: chatMessageNetworkServices,
        userServices: userServices,
        authServices: authServices
    )
}

// MARK: Factories

extension MainDependencyContainer: AuthViewControllerFactory {
    func createLoginViewController(for coordinator: Authenticating & CreatingAccount) -> LoginViewController {
        let viewModel = AuthViewModel(authServices: authServices, userServices: userServices)
        let view = LoginView(viewModel: viewModel)
        let viewController = LoginViewController(coordinator: coordinator, viewModel: viewModel, view: view)
        return viewController
    }
    
    func createSignupViewController(for coordinator: Authenticating & LoggingIn) -> SignupViewController {
        let viewModel = AuthViewModel(authServices: authServices, userServices: userServices)
        let view = SignupView(viewModel: viewModel)
        let viewController = SignupViewController(coordinator: coordinator, viewModel: viewModel, view: view)
        return viewController
    }
}

extension MainDependencyContainer: ChatsViewControllerFactory {
    func createChatsTableViewController(for coordinator: Chatting) -> ChatsTableViewController {
        let viewModel = ChatsTableViewModel(userServices: userServices,
                                            chatRoomServices: chatRoomServices,
                                            chatMessageServices: chatMessageServices)
        
        let viewController = ChatsTableViewController(coordinator: coordinator, viewModel: viewModel)
        return viewController
    }
    
    func createChatRoomViewController(for coordinator: Coordinator, chatRoom: ChatRoom) -> ChatRoomViewController {
        let viewModel = ChatRoomViewModel(chatMessageServices: chatMessageServices, userServices: userServices)
        let view = ChatRoomView()
        let viewController = ChatRoomViewController(coordinator: coordinator, chatRoom: chatRoom, viewModel: viewModel, view: view)
        return viewController
    }
}

extension MainDependencyContainer: CallsTableViewControllerFactory {
    func createCallsTableViewController(for coordinator: Coordinator) -> CallsTableViewController {
        let viewController = CallsTableViewController(coordinator: coordinator)
        return viewController
    }
}

extension MainDependencyContainer: SettingsTableViewControllerFactory {
    func createSettingsTableViewController(for coordinator: SettingsCoordinator, settingsSections: [SettingsSection]? = nil) -> SettingsTableViewController {
        
        let viewModel = SettingsViewModel(authServices: authServices)
        let viewController = SettingsTableViewController(coordinator: coordinator, viewModel: viewModel)
        
        let settingsSections = settingsSections ?? SettingsSectionsFactory.createRootSettingsSections(forTargetVC: viewController)
        
        let dataSource = SettingsDataSource(settingsSections: settingsSections)
        viewController.datasource = dataSource
        
        return viewController
    }
    
}

