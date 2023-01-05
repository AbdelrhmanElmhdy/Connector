//
//  MainViewControllerFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 29/12/2022.
//

import Foundation

class MainViewControllerFactory {
	let dependencyContainer: DependencyContainer
	lazy var settingsSectionFactory = SettingsSectionsFactory(
		userPreferences: dependencyContainer.userDefaultsManager.userPreferences
	)
	
	init(dependencyContainer: DependencyContainer) {
		self.dependencyContainer = dependencyContainer
	}
}

extension MainViewControllerFactory: AuthViewControllersFactory {
	
	func createLoginViewController(for coordinator: Authenticating & CreatingAccount) -> LoginViewController {
		let viewModel = LoginViewModel(authService: dependencyContainer.authService,
																	 userService: dependencyContainer.userService)
		let view = LoginView(viewModel: viewModel)
		let dataBinder = LoginViewAndViewModelBinder(view: view, viewModel: viewModel)
		
		let viewController = LoginViewController(
			coordinator: coordinator, view: view, viewModel: viewModel, dataBinder: dataBinder
		)
		return viewController
	}
	
	func createSignupViewController(for coordinator: Authenticating & LoggingIn) -> SignupViewController {
		let viewModel = SignupViewModel(authService: dependencyContainer.authService,
																		userService: dependencyContainer.userService)
		let view = SignupView(viewModel: viewModel)
		let dataBinder = SignupViewAndViewModelBinder(view: view, viewModel: viewModel)
		
		let viewController = SignupViewController(
			coordinator: coordinator, view: view, viewModel: viewModel, dataBinder: dataBinder
		)
		return viewController
	}
	
}

extension MainViewControllerFactory: ChatViewControllersFactory {
	func createChatsTableViewController(for coordinator: Chatting) -> ChatsTableViewController {
		let viewModel = ChatsTableViewModel(userService: dependencyContainer.userService,
																				chatRoomService: dependencyContainer.chatRoomService,
																				chatMessageService: dependencyContainer.chatMessageService)
		
		let viewController = ChatsTableViewController(coordinator: coordinator, viewModel: viewModel)
		return viewController
	}
	
	func createChatRoomViewController(for coordinator: Coordinator, chatRoom: ChatRoom) -> ChatRoomViewController {
		let viewModel = ChatRoomViewModel(chatMessageService: dependencyContainer.chatMessageService,
																			userService: dependencyContainer.userService)
		let view = ChatRoomView()
		let viewController = ChatRoomViewController(coordinator: coordinator, chatRoom: chatRoom, viewModel: viewModel, view: view)
		return viewController
	}
}


extension MainViewControllerFactory: CallViewControllersFactory {
	func createCallsTableViewController(for coordinator: Coordinator) -> CallsTableViewController {
		let viewController = CallsTableViewController(coordinator: coordinator)
		return viewController
	}
}

extension MainViewControllerFactory: SettingsViewControllersFactory {
	func createSettingsTableViewController(for coordinator: LoggingOut & DisclosingSettings,
																				 settingsSections: [SettingsSection]? = nil) -> SettingsTableViewController {
		
		let viewModel = SettingsViewModel(userPreferencesService: dependencyContainer.userPreferencesService,
																			authService: dependencyContainer.authService)
		let viewController = SettingsTableViewController(coordinator: coordinator, viewModel: viewModel)
		
		let settingsSections = settingsSections ?? settingsSectionFactory.createRootSettingsSections(forViewController: viewController)
		
		let dataSource = SettingsDataSource(settingsSections: settingsSections)
		viewController.datasource = dataSource
		
		return viewController
	}
	
}
