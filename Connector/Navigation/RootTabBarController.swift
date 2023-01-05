//
//  RootTabBarViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit

class RootTabBarController: UITabBarController {
	
	unowned var coordinator: Coordinator
	
	init(coordinator: Coordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)      
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
}
