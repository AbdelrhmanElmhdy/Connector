//
//  RootTabBarViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit

class RootTabBarViewController: UITabBarController {

    let chatsTableViewController = ChatsTableViewController()
    let callsViewController = CallsViewController()
    let settingsViewController = SettingsViewController()
    var isListeningForMessages = false
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsTableViewController())
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
        configureTabBar()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loggedIn = UserDefaultsManager.isLoggedIn
        if loggedIn { listenForMessages() } else { presentAuthenticationStack() }
        
        configureNavigationBar()
    }
    
    func configureTabBar() {
        chatsTableViewController.tabBarItem.image = UIImage(systemName: "message.fill")
        chatsTableViewController.title = "Chats".localized
        
        callsViewController.tabBarItem.image = UIImage(systemName: "phone.fill")
        callsViewController.title = "Calls".localized
        
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
    
    func presentAuthenticationStack() {
        let authNavigationController = UINavigationController(rootViewController: LoginViewController())
        authNavigationController.modalPresentationStyle = .fullScreen
        present(authNavigationController, animated: false)
    }
    
    func listenForMessages() {
        guard !isListeningForMessages else { return }
        NetworkManager.listenForIncomingMessages(completionHandler: ChatMessagesManager.shared.incomingMessagesHandler)
        isListeningForMessages = true
    }
    
    func configureNavigationBar() {
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
}
