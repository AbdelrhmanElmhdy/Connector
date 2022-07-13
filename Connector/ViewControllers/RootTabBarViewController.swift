//
//  RootTabBarViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit

class RootTabBarViewController: UITabBarController {

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    // Override selectedViewController for user initiated changes
    override var selectedViewController: UIViewController? {
        didSet {
            tabChangedTo(selectedIndex: selectedIndex)
        }
    }
    
    // Override selectedIndex for programmatic changes
    override var selectedIndex: Int {
        didSet {
            tabChangedTo(selectedIndex: selectedIndex)
        }
    }
    
    var screenTitles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaultsManager.isLoggedIn {
            let user = User(id: UUID(), name: "Abdelrhman Elmahdy", username: "AbdrhmanElmhdy", email: "AbdelrhmanElmahdy@gmail.com", imageUrl: "https://abdlrhmanElmhdy.me/image")
            
            UserDefaultsManager.user = user
        }
        
        configureTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func configureTabBar() {
        let chatsTableViewController = ChatsTableViewController()
        chatsTableViewController.tabBarItem.image = UIImage(systemName: "message.fill")
        chatsTableViewController.title = "Chats".localized
        
        let callsViewController = CallsViewController()
        callsViewController.tabBarItem.image = UIImage(systemName: "phone.fill")
        callsViewController.title = "Calls".localized
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem.image = UIImage(systemName: "gear")
        settingsViewController.title = "Settings".localized
        
        viewControllers = [chatsTableViewController, callsViewController, settingsViewController]
        
        screenTitles = [
            "Chats".localized,
            "Calls".localized,
            "Settings".localized,
        ]
        
        title = screenTitles?.first
    }
    
    // Handle new selection
    func tabChangedTo(selectedIndex: Int) {
        title = screenTitles?[selectedIndex]
        guard let selectedViewController = selectedViewController as? UISearchControllerDelegate else {
            navigationItem.searchController = nil
            return
        }
        
        searchController.delegate = selectedViewController
        
        guard let selectedViewController = selectedViewController as? UISearchResultsUpdating else {
            navigationItem.searchController = nil
            return
        }
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = selectedViewController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(title ?? "")".localized
    }
}
