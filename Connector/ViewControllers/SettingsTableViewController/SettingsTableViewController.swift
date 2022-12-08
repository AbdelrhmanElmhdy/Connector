//
//  SettingsTableViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit
import FirebaseAuth

let settingsCellReuseIdentifier = "settingsCellReuseIdentifier"

class SettingsTableViewController: UITableViewController {
    // MARK: Properties
        
    unowned var coordinator: LoggingOut & DisclosingSettings
    
    let viewModel: SettingsViewModel
    var datasource: SettingsDataSource?
    
    // MARK: Initialization
        
    init(coordinator: LoggingOut & DisclosingSettings, viewModel: SettingsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        tableView.dataSource = datasource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    // MARK: Convenience
    
    func configureNavBar() {
        let isRootSettingsViewController = !(navigationController?.previousViewController is SettingsTableViewController)
        
        if isRootSettingsViewController {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        } else {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsOption = datasource?.getSettingsOption(forIndexPath: indexPath)
        
        switch settingsOption {
        case let .disclosure(option):
            coordinator.disclose(settings: option.children, settingsTitle: option.label)
        case let .button(option):
            option.tabHandler()
        case .switch, .option, .none:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
