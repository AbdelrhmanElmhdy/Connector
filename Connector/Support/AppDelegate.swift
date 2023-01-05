//
//  AppDelegate.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/06/2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	static var shared: AppDelegate { _shared }
	private static var _shared: AppDelegate!
	
	let dependencyContainer = MainDependencyContainer()
	lazy var viewControllerFactory = MainViewControllerFactory(dependencyContainer: dependencyContainer)
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Self._shared = self
		FirebaseApp.configure()
		return true
	}
	
}
